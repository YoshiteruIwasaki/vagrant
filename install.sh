#!/bin/bash

timedatectl set-timezone Asia/Tokyo
localectl set-locale LANG=ja_JP.utf8
yum update -y
yum install -y gcc nmap lsof unzip readline-devel zlib-devel wget vim expect xauth xorg-x11-xauth xorg-x11-apps.x86_64  x11 fonts
#POSTGRES_PASS=$(mkpasswd)
#echo 'postgres password'
#echo ${POSTGRES_PASS}
#MYSQL_PASS=$(mkpasswd)
#echo 'mysql password'
#echo ${MYSQL_PASS}
POSTGRES_PASS=";mbmV89Cw"
MYSQL_PASS=";mbmV89Cw"

#git
yum install -y git

#ruby
yum install -y ruby

#postgresql
yum localinstall -y https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-centos96-9.6-3.noarch.rpm
yum install -y postgresql96*
/usr/pgsql-9.6/bin/postgresql96-setup initdb
systemctl enable postgresql-9.6
sed -i -e "s/local   all             all                                     peer/local   all             all                                     trust/" /var/lib/pgsql/9.6/data/pg_hba.conf
sed -i -e "s/host    all             all             127.0.0.1/32            ident/host    all             all             127.0.0.1/32            trust/" /var/lib/pgsql/9.6/data/pg_hba.conf
sed -i -e "s/host    all             all             ::1/128                 ident/host    all             all             ::1/128                 trust/" /var/lib/pgsql/9.6/data/pg_hba.conf
echo 'host    all             all             0.0.0.0/0            trust' >> /var/lib/pgsql/9.6/data/pg_hba.conf  
echo "listen_addresses = '*'" >> /var/lib/pgsql/9.6/data/postgresql.conf  
sed -i -e "s/log_line_prefix = '< %m > '/log_line_prefix = '<%t %u %d>'/" /var/lib/pgsql/9.6/data/postgresql.conf
echo "& ${POSTGRES_PASS} ${POSTGRES_PASS}" | passwd --stdin postgres
systemctl start postgresql-9.6

#mysql
yum localinstall -y http://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
yum install -y mysql-community-server
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
MYSQL_DEFAULT_PASS=$(cat /var/log/mysqld.log | grep "A temporary password is generated for" | awk '{print $NF}')
echo ${MYSQL_DEFAULT_PASS}
echo "& ${MYSQL_DEFAULT_PASS} ${MYSQL_PASS} ${MYSQL_PASS} y ${MYSQL_PASS} ${MYSQL_PASS} y y y y y" | mysql_secure_installation

 GRANT ALL PRIVILEGES ON *.* TO root@"192.168.%" IDENTIFIED BY '${MYSQL_PASS}' WITH GRANT OPTION;
      
#apache
yum install -y httpd mod_ssl
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
echo 'export PATH="/usr/local/activator:$PATH"' >> ~/.bash_profile
source ~/.bash_profile

#heroku
wget -qO- https://toolbelt.heroku.com/install.sh | sh
echo 'export PATH="/usr/local/heroku/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile

#php
yum install epel-release
yum localinstall -y http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
yum install -y --enablerepo=remi,remi-php70 php php-devel php-mbstring php-pdo php-gd php-cli php-pdo php-mysqlnd php-pear.noarch php-xml php-mcrypt

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

#password
echo 'postgres password'
echo ${POSTGRES_PASS}
echo 'POSTGRES_PASS=${POSTGRES_PASS}' >> ~/.bash_profile
source ~/.bash_profile

echo 'mysql password'
echo ${MYSQL_PASS}
echo 'MYSQL_PASS=${MYSQL_PASS}' >> ~/.bash_profile
source ~/.bash_profile

#GNOME
yum -y groups install "GNOME Desktop"
#yum -y groups install "KDE Plasma Workspaces"
yum -y groups install "Basic Web Server" "Server with GUI" "Development Tools"
#startx
systemctl set-default graphical.target
systemctl get-default
systemctl start graphical.target
 
yum install -y firefox
yum localinstall -y https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
wget http://ftp.jaist.ac.jp/pub/eclipse/oomph/epp/neon/R2a/eclipse-inst-linux64.tar.gz
tar -zxvf eclipse-inst-linux64.tar.gz
wget http://ftp.jaist.ac.jp/pub/mergedoc/pleiades/4.6/pleiades-4.6.2-ultimate-win-64bit_20161221.zip 
unzip pleiades-4.6.2-ultimate-win-64bit_20161221.zip 
cd eclipse-installer/
./eclipse-inst
ln -s /opt/eclipse/jee-neon/eclipse/ /usr/bin/eclipse
echo '[Desktop Entry]' >> /usr/share/applications/eclipse-4.4.2.desktop
echo 'Encoding=UTF-8' >> /usr/share/applications/eclipse-4.4.2.desktop
echo 'Name=Eclipse 4.4.2' >> /usr/share/applications/eclipse-4.4.2.desktop
echo 'Comment=Eclipse Luna' >> /usr/share/applications/eclipse-4.4.2.desktop
echo 'Exec=/usr/bin/eclipse' >> /usr/share/applications/eclipse-4.4.2.desktop
echo 'Icon=/usr/bin/eclipse/icon.xpm' >> /usr/share/applications/eclipse-4.4.2.desktop
echo 'Categories=Application;Development;Java;IDE' >> /usr/share/applications/eclipse-4.4.2.desktop
echo 'Version=1.0' >> /usr/share/applications/eclipse-4.4.2.desktop
echo 'Type=Application' >> /usr/share/applications/eclipse-4.4.2.desktop
echo 'Terminal=0' >> /usr/share/applications/eclipse-4.4.2.desktop
\cp -arf ../pleiades/eclipse/plugins/* /opt/eclipse/jee-neon/eclipse/plugins/
\cp -arf ../pleiades/eclipse/features/ /opt/eclipse/jee-neon/eclipse/
\cp -arf ../pleiades/eclipse/dropins/* /opt/eclipse/jee-neon/eclipse/dropins/
echo '-javaagent:dropins/MergeDoc/eclipse/plugins/jp.sourceforge.mergedoc.pleiades/pleiades.jar' >>  /opt/eclipse/jee-neon/eclipse/eclipse.ini

echo 'MYSQL_DATABASE_DRIVER="com.mysql.jdbc.Driver"' >> ~/.bash_profile
echo 'MYSQL_DATABASE_URL="jdbc:mysql://localhost:3306/recruit?useUnicode=yes&characterEncoding=utf8&connectionCollation=utf8mb4_general_ci"' >> ~/.bash_profile
echo 'MYSQL_DATABASE_USER="root"' >> ~/.bash_profile
echo 'MYSQL_DATABASE_PASSWORD="${MYSQL_PASS}"' >> ~/.bash_profile

echo 'POSTGRES_DATABASE_DRIVER="org.postgresql.Driver"' >> ~/.bash_profile
echo 'POSTGRES_DATABASE_URL="jdbc:postgresql://localhost:5432/recruit"' >> ~/.bash_profile
echo 'POSTGRES_DATABASE_USER="postgres"' >> ~/.bash_profile
echo 'POSTGRES_DATABASE_PASSWORD="${POSTGRES_PASS}"' >> ~/.bash_profile

echo 'export DATABASE_DRIVER=${POSTGRES_DATABASE_DRIVER}' >> ~/.bash_profile
echo 'export DATABASE_URL=${POSTGRES_DATABASE_URL}' >> ~/.bash_profile
echo 'export DATABASE_USER=${POSTGRES_DATABASE_USER}'>> ~/.bash_profile
echo 'export DATABASE_PASSWORD=${POSTGRES_DATABASE_PASSWORD}' >> ~/.bash_profile

source ~/.bash_profile
