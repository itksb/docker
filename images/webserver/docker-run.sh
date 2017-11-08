#!/bin/bash

# Fail on any error
set -o errexit

change-user-id.sh
enable-xdebug.sh

if [ ! -d "/var/www/html/web" ] ; then
  echo "Directory '/var/www/html/web' does not exists! Ensure that you mounted folder to this container"
  exit 1
fi

cd /var/www/html/web && composer update || true

echo 'starting Apache service'
apache2-foreground