NAME := haproxy
DOCKER_RUN_ARGS ?= \
	-p 8080:80 \
	-v `pwd`/conf.d:/etc/haproxy/conf.d:ro

include ../common.mk
