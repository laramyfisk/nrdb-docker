#!/bin/bash

# Enable necessary Apache modules
a2enmod rewrite expires

# Set mbstring.internal_encoding = UTF-8
sed -i 's/^;mbstring.internal_encoding = .*$/mbstring.internal_encoding = UTF-8/g' /etc/php5/apache2/php.ini

git clone https://github.com/laramyfisk/nrdb.git /app

# TODO: Do we need this? Maybe point Apache right to /app/web?
rm -fr /var/www/html && ln -s /app/web /var/www/html

cd /app

# Download and install Composer
curl -s http://getcomposer.org/installer | php
php composer.phar config -g github-oauth.github.com db33fd2be0039a17bd238c64ef09b1d8ba7d9e18
php composer.phar install

# Make logs and cache writable by the Apache process
chown -R www-data:www-data app/logs app/cache
