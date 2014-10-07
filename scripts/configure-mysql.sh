#!/bin/bash

rm -rf /var/lib/mysql/*
mysql_install_db > /dev/null 2>&1

/usr/bin/mysqld_safe > /dev/null 2>&1 &
/scripts/wait-for-mysql.sh

mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'nrdb'@'localhost' WITH GRANT OPTION"
mysqladmin shutdown
