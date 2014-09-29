#!/bin/bash

/usr/bin/mysqld_safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mysql -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

mysql --user=root --execute='create database symfony collate utf8_general_ci'

cd /app
php app/console doctrine:schema:update --force

mkdir /data
wget http://95.215.45.191/cards.sql -O /data/cards.sql
mysql --user=root --database=symfony < /data/cards.sql

sudo -u www-data php app/console cache:clear --env=prod --no-debug

mysqladmin -uroot shutdown
