# Sensu

[Sensu][] is a monitoring system that doesn't suck.

This is a suite of images, packaging Sensu server, API, client, and
[Uchiwa][] (the dashboard), plus an example
[`docker-compose.yml`][docker-compose] to make all the bits talk to
each other.

[Sensu]: https://sensuapp.org/
[Uchiwa]: https://uchiwa.io/
[docker-compose]: https://docs.docker.com/compose/

## Common functionality (Sensu)

Any configuration should be injected via Docker volumes, and will be
read from files:

- `/etc/sensu/client.json` (client only);
- `/etc/sensu/config.json` (server/API only);
- `/etc/sensu/conf.d/*.json`;
- `/etc/sensu/secrets/*.json`.

Refer to [Sensu docs][] for the details.

[Sensu docs]: https://sensuapp.org/docs/latest/reference/configuration.html

If instead, you wish to generate some simple configuration during
container boot, drop some executable scripts into `/etc/rc.local.d`.
They will be executed using [`run-parts(8)`][run-parts-8], so you may
want to ensure they run before `99-check-sensu-config` does.

[run-parts-8]: https://manpages.debian.org/jessie/debianutils/run-parts.8.en.html

## On Kubernetes

If you're running on [Kubernetes][], you may want to use a
[ConfigMap][] to manage configuration and checks, and [Secrets][] to
manage certificates and passwords.

[Kubernetes]: https://kubernetes.io/
[ConfigMap]: https://kubernetes.io/docs/user-guide/configmap/
[Secrets]: https://kubernetes.io/docs/user-guide/secrets/

For example, to supply the SSL key and certificate for the RabbitMQ
transport:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: sensu-ssl
  namespace: monitoring
data:
  cert.pem:     "base64-encoded certificate"
  key.pem:      "base64-encoded private key"
```

Then, reference the SSL files in Sensu's config, via ConfigMap:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: sensu-client-config
  namespace: monitoring
data:
  rabbitmq.json: |
    {
      "rabbitmq": {
        "ssl": {
          "cert_chain_file":  "/etc/sensu/ssl/cert.pem",
          "private_key_file": "/etc/sensu/ssl/key.pem"
        },
        "host": "my-sensu-server.example.net",
        "port": 5672,
        "vhost": "/sensu",
        "user": "sensu"
      }
    }
  sensu.json: |
    { ... }
  checks.json: |
    { ... }
```

Similarly, to configure the RabbitMQ password:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: sensu-secrets
  namespace: monitoring
data:
  rabbit-secrets.json: "base64-encoded json config"
```

Pay special attention to how [configuration merging][] works in
Sensu - the file `rabbit-secrets.json` (shown below) is referenced in
this setup, and its contents will be picked up by Sensu.

```json
{
  "rabbitmq": {
    "password": "TwoAndAHalfGelatinousKubesIngestedAPedestrian&thenLeft"
  }
}
```

[configuration merging]: https://sensuapp.org/docs/latest/reference/configuration.html#configuration-merging

Finally, consume both in a Pod, ReplicationController, ReplicaSet,
etc:

```yaml
spec:
  containers:
  - name: sensu-client
    image: unit9/sensu-client:latest
    volumeMounts:
    - name: sensu-client-config
      mountPath: /etc/sensu/conf.d
    - name: sensu-secrets
      mountPath: /etc/sensu/secrets
    - name: sensu-ssl
      mountPath: /etc/sensu/ssl
  volumes:
  - name: sensu-client-config
    configMap: {name: sensu-client-config}
  - name: sensu-secrets
    secret: {secretName: sensu-secrets}
  - name: sensu-ssl
    secret: {secretName: sensu-ssl}
```

## Bundled plugins

You may also want to look in `/etc/sensu/plugins` inside the image,
which bundles a few checks useful for monitoring the cluster itself.

```json
{
  "checks": {
    "check-kube": {
      "command": "/etc/sensu/plugins/check-kube.rb",
      "handler": "default",
      "interval": 30,
      "standalone": true,
      "notification": "Cluster check failed",
      "occurrences": 3
    }
  }
}
```
