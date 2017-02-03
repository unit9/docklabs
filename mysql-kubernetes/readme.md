MySQL on Kubernetes
======================

Extends the original mysql docker image to (optionally) read the
secrets from `/etc/mysql-credentials`.

Image Name: `unit9/mysql`


Usage
=====

## Replication controller

    kind: ReplicationController
    apiVersion: v1
    metadata:
      name: mysql-master
    spec:
      replicas: 1  # only one is allowed
      selector:
        app: mysql-master
      template:
        metadata:
          name: mysql-master
          labels:
            app: mysql-master
        spec:
          containers:
            - name: mysql
              image: unit9/mysql:latest
              ports:
                - name: mysql
                  containerPort: 3306
              volumeMounts:
                - name: data-storage
                  mountPath: /var/lib/mysql
                - name: credentials
                  mountPath: /etc/mysql-credentials
          volumes:
            - name: data-storage
              gcePersistentDisk:  # Whatever suits your case
                pdName: mysql-data
                fsType: ext4
            - name: credentials
              secret:
                secretName: mysql-credentials

## Secret

    apiVersion: v1
    kind: Secret
    metadata:
      name: mysql-credentials
    data:
      password: <base64 encoded secret>
