#! /bin/bash

GOOGLE_CLIENT_SECRET="${GOOGLE_CLIENT_SECRET:-EMPTY SECRET}"

echo ${GOOGLE_CLIENT_SECRET} > client-secret.json
gcloud auth activate-service-account --key-file client-secret.json
gcloud components install app-engine-python-extras

tail -f /dev/null
