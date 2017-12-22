#!/usr/bin/env bash

# Usage:  ./run.sh -h DB_SERVER -u USERNAME -r USER_ROLE -d DB_NAME

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -u|--username)
    USERNAME="$2"
    shift # past argument
    shift # past value
    ;;
    -r|--role)
    ROLE="$2"
    shift # past argument
    shift # past value
    ;;
    -h|--host)
    HOST="$2"
    shift # past argument
    shift # past value
    ;;
    -d|--dbname)
    DBNAME="$2"
    shift # past argument
    shift # past value
    ;;
    --default)
    DEFAULT=YES
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [ -z ${USERNAME+x} ]; then echo "username is unset"; exit 1 ; fi
if [ -z ${ROLE+x} ]; then echo "role is unset"; exit 1 ; fi
if [ -z ${HOST+x} ]; then echo "host is unset"; exit 1 ; fi
if [ -z ${DBNAME+x} ]; then echo "dbname is unset"; exit 1 ; fi

FILE="${DBNAME}.backup.sql"
INTERNAL_FOLDER='/app'

command="pg_dump -v --host ${HOST} --username ${USERNAME} --role ${ROLE} --encoding=UTF-8 --file ${INTERNAL_FOLDER}/${FILE} ${DBNAME}"

# echo "command to execute: ${command}"

docker run -it \
    --rm \
    --user "$(id -u):$(id -g)" \
    -v /etc/passwd:/etc/passwd:ro \
    -v `pwd`/dump:/app \
    postgres:10.1 \
    ${command}
