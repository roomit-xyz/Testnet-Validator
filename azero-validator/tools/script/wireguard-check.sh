#!/bin/bash

name_service="WireGuard-Connection"
line="Timeout"
server="10.69.69.254 10.69.69.1 10.69.69.101 10.69.69.102"
hostname=`hostname`
wg_config=`hostname -s`


for i in `echo ${server}`
do
  ping -c3 $i  > /dev/null
  if ! [ $? -eq 0 ]
  then 
      telegram-send --format text   "${hostname} | ${name_service} | WARNING - $i - $line"
      echo "`date` `hostname` - $i Timeout"
      echo "`date` `hostname` - $i Restarting WireGuard"
      /usr/bin/systemctl stop wg-quick@${wg_config}
      echo "nameserver 8.8.8.8" > /etc/resolve.conf
      /usr/bin/systemctl start wg-quick@${wg_config}
      echo "`date` `hostname` - $i Test Connection"
      ping -c3 $i
      exit 0
  else
      echo "`date` `hostname` - $i Connection Established"
  fi
done
