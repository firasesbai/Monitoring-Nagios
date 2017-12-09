#!/bin/bash
# Download the latest version of NRPE and extract its content
wget http://prdownloads.sourceforge.net/sourceforge/nagios/nrpe-2.15.tar.gz
tar -xzf nrpe.2.15.tar.gz
cd nrpe.2.15
#Configure NRPE
sudo ./configure
#Install NRPE
sudo make all
sudo make install-daemon 
sudo make install-daemon-config
