NAME := postgres-dumper
DOCKER_RUN_ARGS := \
	--link postgres:postgres \
	-v ${PWD}/backups:/var/backups \
	-e PGHOST=postgres \
	-e PGUSER=postgres \
	-e PGPASSWORD=1234

include ../common.mk
