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
  [ "--kubernetes-api", "-a", GetoptLong::OPTIONAL_ARGUMENT ],
  [ "--dump-all", "-d", GetoptLong::OPTIONAL_ARGUMENT ],
)

CHECKS_RESOURCES = {
  "cpuRequestsFraction"    => {:w => 80, :c => 90, :op => :>=},
  "cpuLimitsFraction"      => {:w => 80, :c => 90, :op => :>=},
  "memoryRequestsFraction" => {:w => 80, :c => 90, :op => :>=},
  "memoryLimitsFraction"   => {:w => 80, :c => 90, :op => :>=},
  "allocatedPodsFraction"  => {:w => 80, :c => 90, :op => :>=},
}

CHECKS_CONDITIONS = {
  "DiskPressure"       => { :expect => "False", :status => :c },
  "MemoryPressure"     => { :expect => "False", :status => :c },
  "NetworkUnavailable" => { :expect => "False", :status => :c },
  "OutOfDisk"          => { :expect => "False", :status => :c },
  "Ready"              => { :expect => "True",  :status => :w },
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
    CHECKS_RESOURCES.collect { |metric, thresholds|
      value = self.info["allocatedResources"][metric]
      operator = thresholds[:op]
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
      check = CHECKS_CONDITIONS[condition["type"]]
      return if check.nil?
      status = :ok
      status = check[:status] if condition["status"] != check[:expect]
      ({
         :node      => self.name,
         :message   => "#{condition["message"]} (node: #{@name})",
         :condition => condition,
         :expected  => check[:expect],
         :status    => status,
       })
    }
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

def main
  OPTS.each { |opt, arg|
    case opt
    when "--help"
      puts "Usage:"
      puts "    #{$PROGRAM_NAME} <-h|--help>"
      puts "    #{$PROGRAM_NAME} [-a|--kubernetes-api = URL] [-d|--dump-all]"
    when "--heapster-url"
      $heapster_url = arg
    when "--dump-all"
      dumpall
      exit
    end
  }
  run_checks
end

main
