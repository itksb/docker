#!/usr/bin/env bash

# Fail on any error
set -o errexit
source .env

PHP_USER_ID=$(id -u)
export PHP_USER_ID

ADMIN_DOCKER_COMPOSE_FILE=docker-compose-admin.yml
WEB_SERVER_MOUNT_PATH=$(pwd)/${WEB_SERVER_MOUNT_REL_PATH}
export WEB_SERVER_MOUNT_PATH


print_help() {
  echo "Working with the service"
  echo "Use: ./run.sh options..."
  echo "Options:"
  echo "        -h         			this help"
  echo "        -s         			start the service"
  echo "        -k         			stop the service"
  echo "        -e <container name> enter to the container"
  echo "        -p         			service status"
}


start_service() {
  echo "==========HELLO FROM DEVELOPMENT ENVIRONMENT========="
  echo "Show logs:"
  echo "docker-compose logs -f"
  echo "Use remote_port=9001 for debug"

  docker-compose -f ${ADMIN_DOCKER_COMPOSE_FILE} build
  docker-compose -f ${ADMIN_DOCKER_COMPOSE_FILE} up -d
}


stop_service() {
  docker-compose -f ${ADMIN_DOCKER_COMPOSE_FILE} stop
  docker-compose -f ${ADMIN_DOCKER_COMPOSE_FILE} rm -f
}

exec_in_container() {
  docker-compose -f ${ADMIN_DOCKER_COMPOSE_FILE} exec "$NAME" bash
}

state() {
  docker-compose -f ${ADMIN_DOCKER_COMPOSE_FILE} ps
}


exec_console() {
  echo "Run bash console in container. Web server is not running in this mode ";
  docker-compose -f ${ADMIN_DOCKER_COMPOSE_FILE} build
  docker run -it \
  -e http_proxy=${http_proxy} \
  -e https_proxy=${https_proxy} \
  -e PHP_USER_ID=${PHP_USER_ID} \
  -e COMPOSER_ALLOW_SUPERUSER=1 \
  -e COMPOSER_API_TOKEN=${COMPOSER_API_TOKEN} \
  -p8080:80 \
  -v ${WEB_SERVER_MOUNT_PATH}:/var/www/html/ \
  --rm  \
  --user www-data \
  ${WEB_SERVER_IMAGE_NAME} \
  bash
}


if [ $# = 0 ]; then
    print_help
fi


while getopts ":hskcrRdDe:p" opt;
do
  case $opt in
	h) print_help
	;;
	s) start_service
	;;
	k) stop_service
	;;
	e) NAME=$OPTARG;
	   exec_in_container
	;;
	p) state
	;;
	c) exec_console
	;;
	*) echo 'Wrong key! Run "run.sh -h" for help'
	  exit 1
	;;
  esac
done
