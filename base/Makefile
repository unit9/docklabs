all: build

build: docker-init
	@docker build -t unit9/base:latest .

run: build
	@docker run --rm -ti unit9/base

shell: build
	@docker run --rm -ti unit9/base bash

clean:
	@- rm -f docker-init

docker-init: docker-init.go
	go build docker-init.go

push:
	@docker push unit9/base:latest


.PHONY: all build run shell clean push
