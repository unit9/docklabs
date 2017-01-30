# Sensu client

[Sensu][] is a monitoring system that doesn't suck.

[Sensu]: https://sensuapp.org/

This image packages Sensu itself, plus `run` scripts to run the
client.

Any configuration should be injected via Docker volumes, and will be
read (in order) from files: `/etc/sensu/client.json`,
`/etc/sensu/conf.d/*.json`, and finally
`/etc/sensu/secrets/secrets.json`. Refer to [Sensu docs][] for details
on configuring the client.

[Sensu docs]: https://sensuapp.org/docs/latest/reference/configuration.html

If instead, you wish to generate some simple configuration during
container boot, add a script named `/etc/rc.local.sensu`, which (if
exists) will be run before config validation happens.

## On Kubernetes

If you're running on [Kubernetes][], you may want to use a
[ConfigMap][] to manage configuration and checks, and [Secrets][] to
manage certificates and passwords.

[Kubernetes]: https://kubernetes.io/
[ConfigMap]: https://kubernetes.io/docs/user-guide/configmap/
[Secrets]: https://kubernetes.io/docs/user-guide/secrets/

For example, to supply the SSL key, certificate, and password for the
RabbitMQ transport:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: sensu-client-secrets
  namespace: monitoring
data:
  cert.pem:     "base64-encoded certificate"
  key.pem:      "base64-encoded private key"
  secrets.json: "base64-encoded json config"
```

Pay special attention to how [configuration merging][] works in
Sensu - the file `secrets.json` is referenced in this image as the
last path where Sensu will look for its configuration.

[configuration merging]: https://sensuapp.org/docs/latest/reference/configuration.html#configuration-merging

Then, reference these files in Sensu's config, via ConfigMap:

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
          "cert_chain_file":  "/etc/sensu/secrets/cert.pem",
          "private_key_file": "/etc/sensu/secrets/key.pem"
        },
        "host": "my-sensu-server.example.net",
        "port": 5671,
        "vhost": "/sensu",
        "user": "sensu",
        "password": ""
      }
    }
  sensu.json: |
    { ... }
  checks.json: |
    { ... }
```

Note: because `/etc/sensu/secrets/secrets.json` is processed last
when Sensu loads the configuration, it's a good idea to put things
like the RabbitMQ password in there:

```json
{
  "rabbitmq": {
    "password": "TwoAndAHalfGelatinousKubesIngestedAPedestrian&thenLeft"
  }
}
```

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
    - name: sensu-client-secrets
      mountPath: /etc/sensu/secrets
  volumes:
  - name: sensu-client-config
    configMap:
      name: sensu-client-config
  - name: sensu-client-secrets
    secret:
      secretName: sensu-client-secrets
```

You may also want to look at the daughter image
`unit9/sensu-client-kubernetes`, which bundles a few checks useful for
monitoring the cluster itself.
