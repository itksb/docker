#!/bin/bash

# Fail on any error
set -o errexit

# Set permissions based on ENV variable (debian only)
if [ 0 -ne "${PHP_USER_ID:-0}" ] ; then
    usermod -u ${PHP_USER_ID} www-data
    echo "Changed UID to ${PHP_USER_ID} for user www-data"
fi
