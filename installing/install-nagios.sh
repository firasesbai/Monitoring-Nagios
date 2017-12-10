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
#Install build dependencies 
sudo apt-get install build-essential libgd2-xpm apache2-utils unzip
#Create Nagios user and group 
sudo useradd nagios 
sudo groupadd nagcmd
sudo usermod -a -G nagcmd nagios 
#Add the web server user 
sudo usermod -G nagcmd www-data 
#Download the latest stable version of Nagios Core and extract its content 
wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.2.4.tar.gz
tar -xzf nagios-4.2.4.tar.gz
cd nagios-4.2.4
#Configure Nagios Core 
sudo ./configure --with-nagios-group=nagios --with-command-group=nagcmd
sudo make all
sudo make install
sudo make install-init
sudo make install-config
sudo make install-commandmode
#Install Nagios web interface
sudo make install-webconf
#For this last command you may encounter an error. For that replace the last command with:
sudo /usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-available/nagios.conf
#Copy evenhandler directory to the Nagios directory
sudo cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/
sudo chown -R nagios:nagios /usr/local/nagios/libexec/eventhandlers
#Check nagios conf file for any erros:
sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

#Configure Apache
#Enable the Apache rewrite and cgi modules
sudo a2enmod rewrite
sudo a2enmod cgi
#Use htpasswd to create an admin user, called "nagiosadmin", that can access the Nagios web interface:
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
#Enter password at prompt 
#Create a symbolic link of nagios.conf to the sites-enabled directory 
sudo ln -s /etc/apache2/sites-available/nagios.conf /etc/apache2/sites-enabled/
#Restart Apache 
sudo service nagios restart


