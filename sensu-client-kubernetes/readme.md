# Sensu client on Kubernetes

This image leverages [Sensu][] to monitor and report on the health of
your [Kubernetes][] cluster via [sensu-plugins-kubernetes][].

[Sensu]: https://sensuapp.org/
[Kubernetes]: https://kubernetes.io/
[sensu-plugins-kubernetes]: https://github.com/sensu-plugins/sensu-plugins-kubernetes

## Example checks configuration

Install these checks in `/etc/sensu/conf.d` (e.g. with a [ConfigMap][]).

```json
{
  "checks": {
    "kube-nodes-ready": {
      "command": "/opt/sensu/embedded/bin/check-kube-nodes-ready.rb --in-cluster",
      "handler": "default",
      "interval": 30,
      "standalone": true,
      "notification": "Kubernetes nodes not ready",
      "occurrences": 3
    },
    "kube-pods-pending": {
      "command": "/opt/sensu/embedded/bin/check-kube-pods-pending.rb --in-cluster --timeout 60 --restart 3",
      "handler": "default",
      "interval": 30,
      "standalone": true,
      "notification": "Kubernetes pods pending",
      "occurrences": 3
    },
    "kube-service-available-nginx": {
      "command": "/opt/sensu/embedded/bin/check-kube-service-available.rb --in-cluster --list nginx",
      "handler": "default",
      "interval": 30,
      "standalone": true,
      "notification": "Kubernetes nginx down",
      "occurrences": 3
    },
    "kube-apiserver-available": {
      "command": "/opt/sensu/embedded/bin/check-kube-apiserver-available.rb --in-cluster",
      "handler": "default",
      "interval": 30,
      "standalone": true,
      "notification": "Kubernetes API server down",
      "occurrences": 3
    }
  }
}
```

[ConfigMap]: https://kubernetes.io/docs/user-guide/configmap/
