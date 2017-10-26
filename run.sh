#!/usr/bin/env bash

set -e
source .env

print_help() {
  echo "Information"
  echo "Usage: ./run.sh options..."
  echo "Options:"
  echo "    -h  this help"
  echo "    -s  start service"
  echo "    -k  stop service"
  echo "    -e  enter to the running container"
  echo "    -p  service status"
}


start_service() {
  echo "========== PGADMIN 4 ========="
  echo "Open your browser: http://localhost:${APP_EXPOSE_PORT}"
  docker run -d \
  	-p${APP_EXPOSE_PORT}:80 \
  	--name ${APP_CONTAINER_NAME} \
  	--rm \
  	-e "PGADMIN_DEFAULT_EMAIL=${PGADMIN_DEFAULT_EMAIL}" \
	-e "PGADMIN_DEFAULT_PASSWORD=${PGADMIN_DEFAULT_PASSWORD}" \
	dpage/pgadmin4
}


stop_service() {
  docker stop "${APP_CONTAINER_NAME}"
}


exec_in_container() {
  docker exec -it "${APP_CONTAINER_NAME}" bash
}

state() {
  docker ps -f "name=${APP_CONTAINER_NAME}"
}


if [ $# = 0 ]; then
    print_help
fi


while getopts ":hskee:p" opt;
do
  case $opt in
	h) print_help
	;;
	s) start_service
	;;
	k) stop_service
	;;
	e) exec_in_container
	;;
	p) state
	;;
	*) echo 'Wrong key! Run "run.sh -h" for help'
	  exit 1
	;;
  esac
done