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

mysql --user=root --database=symfony < /data/cards.sql

mysqladmin -uroot shutdown
