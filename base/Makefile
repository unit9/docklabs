all: build

build: docker-init
	@docker build -t unit9/base:latest .

run: build
	@docker run --rm -ti --name base unit9/base

clean:
	@- rm -f docker-init

docker-init: docker-init.go
	go build docker-init.go

push:
	@docker push unit9/base:latest


.PHONY: all build run clean push
