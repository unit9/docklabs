all: build

build:
	@docker build -t unit9/build_node6:latest .

run: build
	@docker run --rm -ti --name build_node6 unit9/build_node6

push:
	@docker push unit9/build_node6:latest

.PHONY: all build run push
