#!/bin/bash

sudo /usr/bin/mysqld_safe > /dev/null 2>&1 &
/scripts/wait-for-mysql.sh

mysql --execute='create database symfony collate utf8_general_ci'
php /home/nrdb/app/app/console doctrine:schema:update --force
mysql --database=symfony < <(curl http://95.215.45.191/cards.sql)
php /home/nrdb/app/app/console cache:clear --env=prod --no-debug
mysqladmin shutdown
