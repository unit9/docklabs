#!/usr/bin/env ruby
require "date"
require "getoptlong"
require "json"
require "net/http"
require "openssl"
require "uri"

$kubernetes_api = "https://kubernetes.default"

OPTS = GetoptLong.new(
  [ "--help", "-h", GetoptLong::NO_ARGUMENT ],
  [ "--kubernetes-api", "-a", GetoptLong::REQUIRED_ARGUMENT ],
  [ "--dump-all", "-d", GetoptLong::NO_ARGUMENT ],
  [ "--explain", "-e", GetoptLong::NO_ARGUMENT ],
  [ "--resources", "-r", GetoptLong::REQUIRED_ARGUMENT ],
  [ "--conditions", "-c", GetoptLong::REQUIRED_ARGUMENT ],
)

$checks_resources = {
  "cpuRequestsFraction"    => {:w => 80, :c => 90},
  "cpuLimitsFraction"      => {:w => 80, :c => 90},
  "memoryRequestsFraction" => {:w => 80, :c => 90},
  "memoryLimitsFraction"   => {:w => 80, :c => 90},
  "allocatedPodsFraction"  => {:w => 80, :c => 90},
}

$checks_conditions = {
  "DiskPressure"       => { :trigger => "True",  :status => :w },
  "MemoryPressure"     => { :trigger => "True",  :status => :w },
  "NetworkUnavailable" => { :trigger => "True",  :status => :c },
  "OutOfDisk"          => { :trigger => "True",  :status => :c },
  "Ready"              => { :trigger => "False", :status => :c },
}

def get(endpoint)
  uri = URI.parse $kubernetes_api + endpoint
  token = File.read("/var/run/secrets/kubernetes.io/serviceaccount/token")
  request = Net::HTTP::Get.new(uri)
  request["authorization"] = "Bearer #{token}"
  http = Net::HTTP.new(uri.hostname, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  http.ca_file = "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
  data = nil
  http.start() {
    http.request(request) { |response|
      if !response.is_a?(Net::HTTPSuccess) then
        raise "HTTP error: #{response.code}: #{uri}"
      end
      data = JSON.parse response.body
    }
  }
  data
end

def merge(hs)
  hs.reduce({}) { |x, y| x.merge y}
end

def pp(obj)
  puts JSON.pretty_generate(obj)
end

class Dashboard
  def nodes
    (get "/api/v1/proxy/namespaces/kube-system" +
         "/services/kubernetes-dashboard/api/v1/node/")["nodes"] \
      .collect { |data|
      Node.new data["objectMeta"]["name"]
    }
  end
  def check_health
    self.nodes.collect(&:check_health).reduce([]) {|x,y| x+y}
  end
end

class Node
  def initialize(name)
    @name = name
    @cached_info = nil
  end
  attr_reader :name

  def info
    if @cached_info.nil?
      @cached_info = (get "/api/v1/proxy/namespaces/kube-system" +
                          "/services/kubernetes-dashboard/api/v1/node/#{@name}")
      self._hydrate
    end
    @cached_info
  end

  def check_resources
    $checks_resources.collect { |metric, thresholds|
      value = self.info["allocatedResources"][metric]
      if not value then
        raise ArgumentError
      end
      operator = :>=
      status = :ok
      message = "#{metric} at #{value} within norm"
      threshold = thresholds[:w]
      if value.send(operator, thresholds[:w]) then
        message = "#{metric} at #{value} breached warning threshold of #{thresholds[:w]}"
        status = :w
      end
      if value.send(operator, thresholds[:c]) then
        threshold = thresholds[:c]
        message = "#{metric} at #{value} breached critical threshold of #{thresholds[:c]}"
        status = :c
      end
      ({
         :node      => self.name,
         :message   => "#{message} (node: #{@name})",
         :metric    => metric,
         :value     => value,
         :threshold => threshold,
         :status    => status,
         :operator  => operator,
       })
    }
  end

  def check_conditions
    self.info["conditions"].collect { |condition|
      check = $checks_conditions[condition["type"]]
      if !check.nil? then
        status = :ok
        status = check[:status] if condition["status"] == check[:trigger]
        ({
           :node      => self.name,
           :message   => "#{condition["message"]} (node: #{@name})",
           :condition => condition,
           :trigger   => check[:trigger],
           :status    => status,
         })
      end
    }.select {|x| !x.nil?}
  end

  def check_health
    self.check_resources + self.check_conditions
  end

  def dump
    ({
       :name => self.name,
       :labels => self.info["labels"],
       :allocatedResources => self.info["allicatedResources"],
       :conditions => self.info["conditions"],
     })
  end

  #private
  def _hydrate
    x = @cached_info["allocatedResources"]["allocatedPods"].to_f /
        @cached_info["allocatedResources"]["podCapacity"].to_f
    @cached_info["allocatedResources"]["allocatedPodsFraction"] =
      (x * 100).round 2
    nil
  end

end

def dumpall
  d = Dashboard.new
  pp merge d.nodes.collect {|n|
    ({ n.name => { :allocatedResources => n.info["allocatedResources"],
                   :conditions => n.info["conditions"] } })
  }
end

def run_checks
  d = Dashboard.new
  failing_checks = d.check_health.select {|r| r[:status] != :ok }
  messages = failing_checks.collect {|r| r[:message] }
  statii = failing_checks.collect {|r| {:w => 1, :c => 2 }[r[:status]] }
  status = (statii + [0]).max
  puts "All OK on this cluster" if status == 0
  messages.each {|m| puts m }
  exit status
end

def parse_arg_conditions(arg)
  merge arg.split(",").collect { |s|
    m = /^([A-z]+):(True|False)=([wc])$/.match s
    if not m then
      raise ArgumentError
    end
    { m[1] => { :trigger => m[2], :status => m[3].to_sym } }
  }
end

def parse_arg_resources(arg)
  merge arg.split(",").collect { |s|
    m = /^([A-z]+)(:w=(\d+))?(:c=(\d+))?$/.match s
    if not m then
      raise ArgumentError
    end
    spec = { m[1] => {} }
    if m[3] then
      spec[m[1]][:w] = Integer(m[3])
    end
    if m[5] then
      spec[m[1]][:c] = Integer(m[5])
    end
    spec
  }
end

def usage
  puts "Usage:"
  puts "    #{$PROGRAM_NAME} <-h|--help>"
  puts "    #{$PROGRAM_NAME} [-d] [-a URL] [-c c1,c2] [-r r1,r2]"
end

def help
  usage
  puts "Options:"
  puts "    (-h | --help)                Show this help"
  puts "    (-d | --dump-all)            Dump all acquired info"
  puts "    (-a | --kubernetes-api) URL  Talk to k8s API there"
  puts "    (-c | --conditions) c1,c2    Only check these conditions"
  puts "    (-r | --resources) r1,r2     Only check these resources"
  puts "    (-e | --explain)             Explain what would be checked"
  puts "Condition spec: condition(:w=W|:c=C) where:"
  puts "    condition  Condition name"
  puts "    :W=w      Warning  if condition is W (True|False)"
  puts "    :C=c      Critical if condition is C (True|False)"
  puts "Resource threshold spec: resource[:w=W][:c=C] where:"
  puts "    resource  Resource name"
  puts "    :w=W      Warning  threshold W (0-100)"
  puts "    :c=C      Critical threshold C (0-100)"
  puts "Example condition specs:"
  puts "    DiskPressure:True=w"
  puts "    Ready:False=c"
  puts "Example resource specs:"
  puts "    cpuRequestsFraction:w=80:c=90"
  puts "    cpuLimitsFraction:c=85"
end

def explain
  puts "Current conditions to check for:"
  $checks_conditions.each { |condition, check|
    puts "    #{condition}:#{check[:trigger]}=#{check[:status]}"
  }
  puts "Current resource thresholds to check for:"
  $checks_resources.each { |resource, thresholds|
    puts "    #{resource}:w=#{thresholds[:w]}:c=#{thresholds[:c]}"
  }
end

def main
  OPTS.each { |opt, arg|
    case opt
    when "--help"
      help
      exit
    when "--kubernetes-api"
      $kubernetes_api = arg
    when "--dump-all"
      dumpall
      exit
    when "--explain"
      explain
      exit
    when "--resources"
      $checks_resources = parse_arg_resources arg
    when "--conditions"
      $checks_conditions = parse_arg_conditions arg
    end
  }
  run_checks
end

main
