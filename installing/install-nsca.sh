#!/bin/bash
#Download the latest version of NSCA and extract its content 
wget http://downloads.sourceforge.net/projects/nagios/nsca-2.x/nsca-2.9.2.tar.gz
tar -xzf nsca.2.9.2.tar.gz
cd nsca.2.9.2
#Configre and compile the NSCA daemon
sudo ./configure
sudo make
#### For the montoring server ####
#Install the NSCA server files manually 
sudo cp src/nsca /usr/local/nagios/bin
sudo cp sample-config/nsca.cfg /usr/local/nagios/etc
#Edit the new file /usr/local/nagios/etc/nsca.cfg by uncommenting the password directive and defining a new one
#### For the target server ####
#Install the NSCA client files manually 
sudo mkdir -p /usr/local/bin /usr/local/etc
sudo cp src/send_nsca /usr/local/etc
sudo cp sample-configsend_nsca.cfg /usr/local/etc
#Edit the new file /usr/local/nagios/etc/nsca.cfg by uncommenting the password directive and defining a new password the same as the one
#set in the monitoring server
