FROM ubuntu:trusty
MAINTAINER Laramy Fisk <laramy.fisk@vfemail.net>

RUN apt-get update && apt-get -y install \
	supervisor \
	openssh-server \
	apache2 \
	libapache2-mod-php5 \
	mysql-server \
	php5-mysql \
	php-apc \
	php5-intl \
	pwgen \
	git \
	curl

ADD configs/my.cnf /etc/mysql/conf.d/my.cnf
ADD scripts/configure-mysql.sh /scripts/configure-mysql.sh
RUN chmod 755 /scripts/configure-mysql.sh
RUN /scripts/configure-mysql.sh

ADD configs/apache_default /etc/apache2/sites-available/000-default.conf
ADD scripts/install-nrdb.sh /scripts/install-nrdb.sh
RUN chmod 755 /scripts/install-nrdb.sh
RUN /scripts/install-nrdb.sh

ADD scripts/load-data.sh /scripts/load-data.sh
RUN chmod 755 /scripts/load-data.sh
RUN /scripts/load-data.sh

VOLUME  ["/etc/mysql", "/var/lib/mysql" ]
EXPOSE 80 3306

ADD configs/supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD configs/supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
ADD scripts /scripts
RUN chmod 755 /scripts/*.sh
CMD ["/scripts/run.sh"]
