#!/bin/bash
#Prerequisites: A LAMP (Linux, Apache , MySQL, PHP) stack is required for the Installation of Nagios Core
#Install Apache web server and allow it in firewall 
sudo apt-get install apache2
sudo ufw allow in "Apache Full"
#Install MySQL 
sudo apt-get install mysql-server
#Install PHP
sudo apt-get install php libapache2-mod-php php-mcrypt php-mysql

#Install Nagios 4

