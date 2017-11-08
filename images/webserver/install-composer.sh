#!/usr/bin/env bash

EXPECTED_SIGNATURE=$(curl https://composer.github.io/installer.sig)
curl -sS https://getcomposer.org/installer -o composer-setup.php
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
then
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi

php composer-setup.php --install-dir=/usr/local/bin/ --filename=composer.phar
RESULT=$?
rm composer-setup.php
exit $RESULT