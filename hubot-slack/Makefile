TAG = unit9/hubot-slack

all: build

build:
	@docker build -t ${TAG}:latest .

run: build
	@docker run --rm -ti ${TAG}

push:
	@docker push ${TAG}:latest

.PHONY: all build run push
