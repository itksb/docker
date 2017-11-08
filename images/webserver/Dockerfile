FROM php:7.1.5-apache
LABEL MAINTAINER Sergey Kochetkov <ksb@itksb.com>

ENV PATH $PATH:/root/.composer/vendor/bin:/var/www/.composer/vendor/bin

ENV LIBS_TO_INSTALL \
git \
g++ \
libicu-dev \
libmcrypt-dev \
zlib1g-dev \
libfreetype6-dev \
libjpeg62-turbo-dev \
libmcrypt-dev \
libpng12-dev \
libpq-dev

ENV PHP_USER_ID=1000 \
	PHP_ENABLE_XDEBUG=0 \
	COMPOSER_ALLOW_SUPERUSER=1 \
	COMPOSER_API_TOKEN=""

RUN apt-get update \
&& apt-get -y install \
$LIBS_TO_INSTALL --no-install-recommends \
# Enable mod_rewrite
&& a2enmod rewrite \
# Install PHP extensions
&& docker-php-ext-install intl \
&& docker-php-ext-install pdo_mysql \
&& docker-php-ext-install pdo_pgsql \
&& docker-php-ext-install pgsql \
&& docker-php-ext-install mbstring \
&& docker-php-ext-install mcrypt \
&& docker-php-ext-install opcache \
&& docker-php-ext-install bcmath \
&& docker-php-ext-install json \
&& docker-php-ext-install iconv \
&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
&& docker-php-ext-install gd \
&& docker-php-ext-install zip \
&& pear config-set http_proxy ${http_proxy} \
&& pecl install xdebug-2.5.5 \
&& pecl install apcu-5.1.8 && echo extension=apcu.so > /usr/local/etc/php/conf.d/apcu.ini \
&& apt-get purge -y g++ \
&& apt-get autoremove -y \
&& rm -r /var/lib/apt/lists/*

# Fix write permissions with shared folders
RUN usermod -u ${PHP_USER_ID} www-data

# Install composer
COPY install-composer.sh /install-composer
RUN chmod +x /install-composer
RUN /install-composer
RUN rm /install-composer


RUN composer.phar global require --no-progress "fxp/composer-asset-plugin:~1.3.1" \
&& composer.phar global require --no-progress "codeception/codeception=2.0.*" \
&& composer.phar global require --no-progress "codeception/specify=*" \
&& composer.phar global require --no-progress "codeception/verify=*" \
&& composer.phar clear-cache

# Apache config and composer wrapper
COPY apache2.conf /etc/apache2/apache2.conf
COPY sites-enabled/ /etc/apache2/sites-enabled/
COPY composer /usr/local/bin/composer
COPY composer.auth.json  /root/.composer/auth.json
# PHP config
COPY custom.php.ini /usr/local/etc/php/php.ini
# PHP debugger config
COPY custom.xdebug.ini /usr/local/etc/php/conf.d/custom.xdebug.ini


# Add configuration files
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY docker-run.sh /usr/local/bin/docker-run.sh
COPY change-user-id.sh /usr/local/bin/change-user-id.sh
COPY enable-xdebug.sh /usr/local/bin/enable-xdebug.sh


RUN chmod 777 \
/usr/local/bin/docker-entrypoint.sh \
/usr/local/bin/docker-run.sh \
/usr/local/bin/change-user-id.sh \
/usr/local/bin/enable-xdebug.sh \
/usr/local/bin/composer

RUN chown -R www-data:www-data /var/www

WORKDIR /var/www/html


ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["docker-run.sh"]