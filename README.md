# Monitoring with Nagios
Network monitoring is a critical and needed function which would have a direct impact on business operations and improve the troubleshooting process. In this context, this project aims to monitor a distant linux server through customised plugins using the open source system Nagios.  
## What is Nagios ?
Nagios is a powerful IT infrastructure monitoring tool. It is designed to ease the work of the system administrator and organizations in general by giving them an overview of their network status. 
## Getting started 
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.
### Prerequisites
#### Installing
* Nagios Core 4.2.4 on the monitoring server: [install-nagios.sh](Monitoring-Nagios/installing/install-nagios.sh)
* Nagios Remote Plugin Executor (**NRPE**) on the target and monitoring server: [install-nrpe.sh](https://github.com/firasesbai/Monitoring-Nagios/installing/install-nrpe.sh)
* Nagios Service Check Acceptor (**NSCA**) on the monitoring server : [install-nsca.sh](https://github.com/firasesbai/Monitoring-Nagios/installing/install-nsca.sh)
### Configuration 
* **Host definition**
1. Open the main Nagios configuration file  
```
sudo nano /usr/local/nagios/etc/nagios.cfg
```
2. Uncomment the following line by removing the # symbol 
```
#cfg_dir=/usr/local/nagios/etc/servers
```
3. Create this directory that will store the configuration file for the target server that we will monitor 
```
sudo mkdir /usr/local/nagios/etc/servers
```
4. Create the configuration file for our target server 
```
sudo touch /usr/local/nagios/etc/servers/server.cfg
```
5. Write the following into this file 
```
define host {
  use       linux-server
  host_name remote-server
  alias     remote-server
  address   192.168.1.5
 }
```
### Custom plugins

**check_throughput:** Calculate the number of received bytes per minute on an interface and corresponding throughput of received traffic.

**check_interface_status:** Sends an alert to the nagios server whenver the interface changes its state from UP to DOWN. 

**Active check: [check_throughput.sh](https://github.com/firasesbai/Monitoring-Nagios/plugins/check_throughput.sh)**

*On the target server*

1. Edit the configuration file of NRPE in order to add the IP address of the Nagios server: Nagios_Server_IP
```
allowed_hosts=127.0.0.1,Nagios_Server_IP
```
2. Change to the directory containing Nagios plugins
```
cd /usr/lib/nagios/plugins
```
3. Create a new file containing the script of the plugin 
```
sudo touch check_throughput.sh
```
4. Make the script executable 
```
sudo chmod +x check_throughput.sh
```
5. Add the script to the NRPE configuration 
```
sudo nano /etc/nagios/nrpe.cfg
command[check_throughput]=/usr/lib/nagios/plugins/check_throughput.sh  
```
6. Restart Nagios NRPE service 
```
sudo service nagios-nrpe-server restart 
```
*On the monitoring server*

7. Verify that the check_nrpe plugin is installed correctly
```
ls /usr/local/nagios/libexec/check_nrpe
```
8. Add a new command related to the check_nrpe in the Nagios Core commands configuration file 
```
sudo nano /usr/local/nagios/etc/objects/commands.cfg
define command {
  command_name    check_nrpe
  command_line    $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
 }
```
9. Define new command corresponding to our plugin in /usr/local/nagios/etc/objects/commands.cfg
```
define command {
  command_name        check_throughput
  command_line        $USER1$/check_nrpe -H $HOSTADDRESS$ -c check_thgroughput $ARG1$ 
 }
```
10. Define new service for this command in configuration file of our server: server.cfg 
```
define service {
  use                 generic-service
  hostname            server
  service_description Throughput 
  check_command       check_throughput
  check_interval      1
  retry_interval      1
 }
```
11. Validate the configuration and restart the nagios core server 
```
sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
sudo service nagios restart 
```
**Passive check: [check_interface_status.sh](https://github.com/firasesbai/Monitoring-Nagios/plugins/check_interface_status.sh)**

*On the monitoring server* 

1. Edit the commands.cfg file and add a definition of the following command 
```
sudo nano /usr/local/nagios/etc/objects/commands.cfg
define command {
  command_name  check_dummy
  command_line  $USER1$/check_dummy $ARG1$ $ARG2$ 
 }
```
2. Edit the server.cfg file and add the following service definition 
```
define service {
  use                     generic-service
  host_name               server
  service_description     Interface-Status  
  active_checks_enabled   0
  passive_checks_enabled  1
  check_freshness         1
  freshness_threshold     43200
  check_command           check_dummy!1!"No passive checks have been made for 12 hours" 
 }
```
3. Validate the configuration and restart the nagios core server 
```
sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
sudo service nagios restart 
```
*On the target server* 

4. Change to the directory containing Nagios plugins
```
cd /usr/lib/nagios/plugins
```
5. Create a new file containing the script of the plugin 
```
sudo touch check_interface_status.sh
```
6. Make the script executable 
```
sudo chmod +x check_interface_status.sh
```
7. Add the script to the NRPE configuration 
```
sudo nano /etc/nagios/nrpe.cfg
command[check_interface_status]=/usr/lib/nagios/plugins/check_interface_status.sh  
```
8. Write a script /usr/local/sbin/[nsca_interface_state.sh](https://github.com/firasesbai/Monitoring-Nagios/plugins/nsca_interface_state.sh) that reads the output of the interface_status plugin, converts it to an nsca-type service check result, and sends it to the nagios server. 
9. Schedule this script to run at regular intervals using **Cron** 
```
sudo crontab -e 
* * * * * /usr/local/sbin/nsca_interface_state.sh
```
## Tests
* Access the Nagios web interface: Nagios_Server_IP/nagios
* Go to Services and you will notice that the new services we have just created have been added successfully. 

## Built with
* Bash programming language 

## Authors 
* **Firas Esbai** - *Initial work* - [Firas Esbai](https://github.com/firasesbai) 
## Licence 
This project is licenced under the [GPL-3.0 Licence](https://www.gnu.org/licenses/gpl-3.0.en.html) - see the [LICENCE](LICENCE.md) file for details.  
