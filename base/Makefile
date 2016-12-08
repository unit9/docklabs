IMAGE    := unit9/base
VERSION  ?= latest
NAME     ?= base


all: build

build:
	@docker build -t ${IMAGE}:${VERSION} .

clean:
	@docker rmi ${IMAGE}:${VERSION}

run: build
	@docker run --rm -ti -P \
		--name ${NAME} ${IMAGE}

shell: build
	@docker run --rm -ti \
		${IMAGE} bash

push:
	@docker push ${IMAGE}:${VERSION}

.PHONY: all build run shell push
