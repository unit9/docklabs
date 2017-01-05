TAG = unit9/shippable

all: build

build:
	@docker build -t ${TAG}:latest .

clean:

run: build
	@docker run --rm -ti ${TAG}

push:
	@docker push ${TAG}:latest


.PHONY: all build run clean push
