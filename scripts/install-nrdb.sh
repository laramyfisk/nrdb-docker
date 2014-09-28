#!/bin/bash

sed -ri -e "s/^upload_max_filesize.*/upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE}/" \
    -e "s/^post_max_size.*/post_max_size = ${PHP_POST_MAX_SIZE}/" /etc/php5/apache2/php.ini

mkdir -p /app
rm -fr /var/www/html
ln -s /app /var/www/html
git clone https://github.com/thimes/deckrunner-bees-knees.git /app

cd /app
cp .htaccess_dist .htaccess
curl -s http://getcomposer.org/installer | php
php composer.phar config -g github-oauth.github.com db33fd2be0039a17bd238c64ef09b1d8ba7d9e18
php composer.phar install
