IMAGE    := unit9/kubenginx
VERSION  ?= latest
NAME     ?= nginx


all: build

build:
	@docker build -t ${IMAGE}:${VERSION} .

clean:
	@docker rmi ${IMAGE}:${VERSION}

run: build
	@docker run --rm -ti -P \
		-v ${PWD}/conf.d/:/etc/nginx/conf.d/ \
		-p 80:80 \
		--name ${NAME} \
		${IMAGE}

shell: build
	@docker run --rm -ti -P \
		-v ${PWD}/conf.d/:/etc/nginx/conf.d/ \
		-p 80:80 \
		--name ${NAME} \
		${IMAGE} bash

push:
	@docker push ${IMAGE}:${VERSION}

.PHONY: all build clean run shell push
