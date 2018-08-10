FROM centos:latest

MAINTAINER "tujuhion" <yanwar.purnama@gmail.com>

ENV container docker

# UPDATE
RUN yum -y install epel-release wget certbot openssl
RUN rpm -ivh http://rpms.litespeedtech.com/centos/litespeed-repo-1.1-1.el7.noarch.rpm
RUN yum -y update

#Install Proftpd
RUN yum -y install proftpd
RUN sed -i "s/ProFTPD server/$HOSTNAME/g" /etc/proftpd.conf

#Install Openlitespeed
RUN mkdir /home/defdomain
RUN mkdir /home/defdomain/{html,logs}
RUN touch home/defdomain/logs/access.log
RUN touch home/defdomain/logs/error.log

RUN yum -y install openlitespeed

# Install PHP 72
RUN yum -y install lsphp72 lsphp72-common lsphp72-mysqlnd lsphp72-process lsphp72-gd lsphp72-mbstring lsphp72-mcrypt lsphp72-opcache lsphp72-bcmath lsphp72-pdo lsphp72-xml lsphp72-json lsphp72-zip lsphp72-xmlrpc lsphp72-pecl-mcrypt

#Setting Up
RUN mv -f /usr/local/lsws/conf/vhosts/Example/ /usr/local/lsws/conf/vhosts/defdomain/
RUN rm -f /usr/local/lsws/conf/vhosts/defdomain/vhconf.conf
RUN rm -f /usr/local/lsws/conf/httpd_config.conf
RUN rm -f /usr/local/lsws/admin/conf/admin_config.conf

ADD conf/vhconf.conf /usr/local/lsws/conf/vhosts/defdomain/vhconf.conf
ADD conf/httpd_config.conf /usr/local/lsws/conf/httpd_config.conf
ADD conf/admin_config.conf /usr/local/lsws/admin/conf/admin_config.conf
ADD file/index.php /home/defdomain/html/index.php

RUN chown lsadm:lsadm /usr/local/lsws/conf/vhosts/defdomain/vhconf.conf
RUN chown lsadm:lsadm /usr/local/lsws/conf/httpd_config.conf
RUN chown lsadm:lsadm /usr/local/lsws/admin/conf/admin_config.conf
RUN chown -R nobody:nobody /home/defdomain/html/

# Generate SSL for Webadmin
RUN mkdir /usr/local/lsws/conf/cert/admin
RUN openssl genrsa -out /usr/local/lsws/conf/cert/admin/admin.key 2048
RUN openssl rsa -in /usr/local/lsws/conf/cert/admin/admin.key -out /usr/local/lsws/conf/cert/admin/admin.key
RUN openssl req -sha256 -new -key /usr/local/lsws/conf/cert/admin/admin.key -out /usr/local/lsws/conf/cert/admin/admin.csr -subj "/CN=localhost"
RUN openssl x509 -req -sha256 -days 365 -in /usr/local/lsws/conf/cert/admin/admin.csr -signkey /usr/local/lsws/conf/cert/admin/admin.key -out /usr/local/lsws/conf/cert/admin/admin.crt

# make sure firewall
EXPOSE 21
EXPOSE 80
EXPOSE 443
EXPOSE 7080

RUN systemctl enable proftpd
CMD ["/usr/sbin/init"]
ENTRYPOINT /usr/local/lsws/bin/lswsctrl start && /bin/bash

