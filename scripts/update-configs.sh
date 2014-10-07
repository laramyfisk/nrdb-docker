#!/bin/bash

a2enmod rewrite expires
sed -i 's/^;mbstring.internal_encoding = .*$/mbstring.internal_encoding = UTF-8/g' /etc/php5/apache2/php.ini
