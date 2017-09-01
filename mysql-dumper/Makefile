NAME := mysql-dumper
DOCKER_RUN_ARGS := \
	--link mysql:mysql \
	-v ${PWD}/backups:/var/backups \
	-v ${PWD}/boto.cfg:/etc/boto.cfg \
	-e GS_PATH=gs://my-test-bucket/backups/ \
	-e MYSQL_HOST=mysql \
	-e MYSQL_USER=root \
	-e MYSQL_PASSWORD=1234

include ../common.mk
