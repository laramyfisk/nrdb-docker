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

# The section below performs the time-consuming work of downloadng Composer 
# modules. It is placed in the beginning as a hack to facilitate development.
# If placed after "ADD /scripts", any change to scripts unders /scripts would
# force re-execution of scripts/install-nrdb.sh, which is quite long.

ADD scripts/create-nrdb-user.sh /scripts/create-nrdb-user.sh
ADD scripts/install-nrdb.sh /scripts/install-nrdb.sh
RUN chmod u+x /scripts/install-nrdb.sh /scripts/create-nrdb-user.sh

ADD configs/sudoers /etc/sudoers
RUN /scripts/create-nrdb-user.sh

USER nrdb
RUN /scripts/install-nrdb.sh
USER root

# End of the time-intensive section. Now we just add the rest of /scripts.
# Everything below will be re-run every time ANY script is changed.

ADD scripts /scripts
RUN chmod 755 /scripts/*.sh
ADD configs/my.cnf /etc/mysql/conf.d/my.cnf
RUN /scripts/configure-mysql.sh
RUN /scripts/update-configs.sh

USER nrdb

# From this point onwards we are under "nrdb" user.

ADD configs/apache_default /etc/apache2/sites-available/000-default.conf
RUN /scripts/load-data.sh

ADD configs/supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf
ADD configs/supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf

#VOLUME ["/etc/mysql", "/var/lib/mysql" ]
#VOLUME ["/home/nrdb/cards"]

EXPOSE 80 3306

CMD ["/scripts/run.sh"]
