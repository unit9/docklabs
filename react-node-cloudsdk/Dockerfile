FROM unit9/react-node:v10.15.3_1

MAINTAINER Tomasz Arendt <tomasz.arendt@unit9.com>

ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
ENV SDK_VERSION 222.0.0
ENV SDK_FILENAME google-cloud-sdk-${SDK_VERSION}-linux-x86_64.tar.gz
ENV PATH ${PATH}:/root/google-cloud-sdk/bin
ENV GAE_PYTHONPATH /root/google_appengine
ENV PYTHONPATH ${PYTHONPATH}${GAE_PYTHONPATH}

ADD fetch_gae_sdk.py /root

RUN curl -O -J https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${SDK_FILENAME} \
    && tar -zxf ${SDK_FILENAME} --directory ${HOME} \
    && python /root/fetch_gae_sdk.py $(dirname "${GAE_PYTHONPATH}")

CMD ["tail -f /dev/null"]