#!/bin/bash

git clone https://github.com/laramyfisk/nrdb.git /home/nrdb/app

cd /home/nrdb/app

# Download and install Composer
curl -s http://getcomposer.org/installer | php
php composer.phar config -g github-oauth.github.com db33fd2be0039a17bd238c64ef09b1d8ba7d9e18
php composer.phar install
