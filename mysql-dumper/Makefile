NAME := postgres-dumper
DOCKER_RUN_ARGS := \
	--link postgres:postgres \
	-v ${PWD}/backups:/var/backups \
	-v ${PWD}/boto.cfg:/etc/boto.cfg \
	-e GS_PATH=gs://my-test-bucket/backups/ \
	-e PGHOST=postgres \
	-e PGUSER=postgres \
	-e PGPASSWORD=1234

include ../common.mk
