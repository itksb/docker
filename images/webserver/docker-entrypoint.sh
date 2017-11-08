#!/bin/bash

# Fail on any error
set -o errexit

change-user-id.sh
enable-xdebug.sh


export PS1="\e[0;35mphd \e[0;37m\u container \h \e[0;32m\w \e[0;0m\n$ "

# Execute CMD
exec "$@"