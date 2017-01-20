#!/bin/bash

timedatectl set-timezone Asia/Tokyo
localectl set-locale LANG=ja_JP.utf8
yum update -y
yum install -y gcc nmap lsof unzip readline-devel zlib-devel wget vim

#git
yum -y install git

#ruby
yum -y install ruby

#postgresql
yum localinstall -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
yum -y install postgresql96*
/usr/pgsql-9.6/bin/postgresql96-setup initdb
systemctl enable postgresql-9.6
sed -i -e "s/local   all             all                                     peer/local   all             all                                     trust/" /var/lib/pgsql/9.6/data/pg_hba.conf
echo 'host    all             all             0.0.0.0/0            trust' >> /var/lib/pgsql/9.6/data/pg_hba.conf  
echo "listen_addresses = '*'" >> /var/lib/pgsql/9.6/data/postgresql.conf  
sed -i -e "s/log_line_prefix = '< %m > '/log_line_prefix = '<%t %u %d>'/" /var/lib/pgsql/9.6/data/postgresql.conf
#echo "& postgres postgres" | passwd postgres
systemctl start postgresql-9.6

#mysql
yum localinstall -y http://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
yum -y install mysql-community-server
systemctl enable mysqld.service
echo "character_set_server=utf8"  >> /etc/my.cnf
echo "default-storage-engine=InnoDB" >>  /etc/my.cnf
echo "innodb_file_per_table" >>  /etc/my.cnf
echo "default_password_lifetime = 0" >>  /etc/my.cnf
echo "[mysql]" >>  /etc/my.cnf
echo "default-character-set=utf8" >>  /etc/my.cnf
echo "[mysqldump]" >>  /etc/my.cnf
echo "default-character-set=utf8" >>  /etc/my.cnf
systemctl start mysqld.service
#echo "& y y mysql mysql y y y y" | mysql_secure_installation
#http://qiita.com/MasahitoShinoda/items/9c2d895084b222ac816a

#apache
yum -y install httpd mod_ssl
systemctl enable httpd.service
systemctl start httpd.service

#java
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.rpm"
yum localinstall -y jdk-8u121-linux-x64.rpm

#play
wget https://downloads.typesafe.com/typesafe-activator/1.3.3/typesafe-activator-1.3.3.zip
unzip typesafe-activator-1.3.3.zip
mv activator-1.3.3 /usr/local
ln -fs /usr/local/activator-1.3.3 /usr/local/activator
echo 'PATH="/usr/local/activator:$PATH"' >> ~/.bash_profile
source ~/.bash_profile

#heroku
wget -qO- https://toolbelt.heroku.com/install.sh | sh
echo 'PATH="/usr/local/heroku/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile

#php
#yum install epel-release
#rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
#yum install --enablerepo=remi,remi-php70 php php-devel php-mbstring php-pdo php-gd php-cli php-pdo php-mysqlnd php-pear.noarch php-xml php-mcrypt

#rm -rf /var/www/html
#ln -fs /vagrant/src /var/www/html
#systemctl restart httpd.service

#firewall
firewall-cmd --zone=public --add-service=http --permanent
firewall-cmd --permanent --zone=public --add-service=postgresql
#systemctl restart firewalld.service
systemctl stop firewalld.service
cp -p /etc/selinux/config /etc/selinux/config.orig
sed -i -e "s|^SELINUX=.*|SELINUX=disabled|" /etc/selinux/config

#git
cd /git
heroku git:clone -a recruitpage
cd recruitpage
activator eclipse
activator compile
activator run