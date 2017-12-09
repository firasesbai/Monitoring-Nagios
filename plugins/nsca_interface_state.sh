#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/sbin/

#### Nagios NSCA wrapper for the bridge interface state passive checks ####

#### Nagios config ####
PLUGINS='/usr/lib/nagios/plugins'
NAGIOS=Nagios_Server_IP

#### Host being checked ####
HOST=server

#### Service check #####
# CRITICAL if the bridge interface is DOWN
SERVICE='Interface-Status'
TEXT=$( ${PLUGINS}/check_interface_state.sh);
RET=$?

#### Send ####
echo -en "${HOST}\t${SERVICE}\t${RET}\t${TEXT}" | send_nsca -c /usr/local/etc/send_nsca.cfg -H $NAGIOS >/dev/null

#### Service check ends ####
exit 0 
