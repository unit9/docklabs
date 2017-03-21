# To be included in Makefiles.
# Define the variable NAME.

VENDOR  ?= unit9
VERSION ?= latest
IMAGE   ?= ${VENDOR}/${NAME}

DOCKERFILE ?= Dockerfile

DOCKER_RUN_ARGS ?=
DOCKER_RUN_CMD	?=
DOCKER_SH_CMD	?= bash

all: build

options:
	@echo "VENDOR	= ${VENDOR}"
	@echo "NAME	= ${NAME}"
	@echo "IMAGE	= ${IMAGE}"
	@echo "VERSION	= ${VERSION}"
	@echo "DOCKER_RUN_ARGS	= ${DOCKER_RUN_ARGS}"

build: ${DOCKERFILE}
	@echo "BUILD ${IMAGE}:${VERSION}"
	@docker build -f ${DOCKERFILE} -t ${IMAGE}:${VERSION} .

clean:
	@echo "RMI ${IMAGE}:${VERSION}"
	@docker rmi ${IMAGE}:${VERSION}

run:
	@echo "RUN ${IMAGE}:${VERSION}"
	@docker run \
		--rm -ti \
		--name ${NAME} \
		--hostname ${NAME} \
		${DOCKER_RUN_ARGS} \
		${IMAGE}:${VERSION} \
		${DOCKER_RUN_CMD}

shell:
	@ DOCKER_RUN_CMD=${DOCKER_SH_CMD} ${MAKE} run

push:
	@echo "PUSH ${IMAGE}:${VERSION}"
	@docker push ${IMAGE}:${VERSION}

# All targets are phony
.PHONY: *
