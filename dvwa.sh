#!/bin/bash

dnf install git php php-mysqli php-gd -y
cd /var/www/html
git clone https://github.com/digininja/dvwa 
chown -R root:root /var/www/html/dvwa
cp /var/www/html/dvwa/config/config.inc.php.dist /var/www/html/dvwa/config/config.inc.php 
dnf install mariadb-server -y

systemctl start mariadb
systemctl enable mariadb
systemctl status mariadb

mysql -u root -e "create database dvwa" 
mysql -u root -e "create user 'dvwa'@'localhost' identified by '123'" 
mysql -u root -e "grant all on dvwa.* to 'dvwa'@'localhost'" 
mysql -u root -e "flush privileges"

setsebool -P httpd_can_network_connect_db 1
echo "jangan lupa setting config.inc.php setelah itu restart httpd"
