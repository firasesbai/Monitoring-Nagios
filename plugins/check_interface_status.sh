#!/bin/bash

#Read the state of the interface eth0
state=$( ip link show eth0 | grep state | awk '{print $9}' )

case $state in
*"UP"*)
echo "OK - The bridge interface is $state."
exit 0
;;
*"DOWN"*)
echo "CRITICAL - The bridge interface is $state."
exit 2
;;
*)
echo "UNKNOWN - The bridge interface state is $state"
exit 3
;;
esac
