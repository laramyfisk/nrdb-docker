FROM ubuntu:trusty
MAINTAINER Laramy Fisk <laramy.fisk@vfemail.net>

RUN apt-get update && apt-get -y install supervisor git apache2 libapache2-mod-php5 mysql-server php5-mysql pwgen php-apc php5-intl curl

ENV PHP_UPLOAD_MAX_FILESIZE 10M
ENV PHP_POST_MAX_SIZE 10M

ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD scripts/configure-mysql.sh /scripts/configure-mysql.sh
RUN chmod 755 /scripts/configure-mysql.sh
RUN /scripts/configure-mysql.sh

ADD apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

ADD scripts/install-nrdb.sh /scripts/install-nrdb.sh
RUN chmod 755 /scripts/install-nrdb.sh
RUN /scripts/install-nrdb.sh

ADD cards.sql /data/cards.sql
ADD scripts/load-data.sh /scripts/load-data.sh
RUN chmod 755 /scripts/load-data.sh
RUN /scripts/load-data.sh

VOLUME  ["/etc/mysql", "/var/lib/mysql" ]
EXPOSE 80 3306

ADD scripts /scripts
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
RUN chmod 755 /scripts/*.sh
CMD ["/scripts/run.sh"]
