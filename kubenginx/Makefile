NAME := kubenginx
DOCKER_RUN_ARGS ?= \
	-v ${PWD}/conf.d/:/etc/nginx/conf.d/ \
	-p 80:80
include ../common.mk
