#!/bin/bash

#Read the number of bytes received on the interface eth0
bytes=$(ifconfig eth0 | grep bytes | awk '{print $2}' | sed 's/bytes://g')

#Read last recorded number of bytes on the interface eth0 from the log file
last_entry=$(awk '/./{line=$0} END {print line}' /tmp/rx_log.txt)

#Check if the log file is empty or not for computing appropriate value of $delta
if [ -s /tmp/rx_log.txt ]
then
	delta=$(expr $bytes - $last_entry)
else
	delta=$bytes
fi

#Update the log file
echo $bytes >> /tmp/rx_log.txt

case $bytes in
[0]*)
echo "OK - $bytes bytes are received ($delta bytes/min). | Throughput=$delta bytes/min"
exit 0
;;
[1-20]*)
echo "WARNING - $bytes bytes are received ($delta bytes/min). | Throughput=$delta bytes/min"
exit 1
;;
[20-100]*)
echo "CRITICAL - $bytes bytes are received ($delta bytes/min)... | Throughput=$delta bytes/min"
exit 2
;;
*)
echo "UNKNOWN - $bytes bytes are received ($delta bytes/min)... | Throughput=$delta bytes/min"
exit 3
;;
esac

