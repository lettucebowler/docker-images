#!/bin/sh
pkill deluge-console
deluge-console --username ${DELUGE_USER} --password ${DELUGE_PASS} status | grep "DHT Nodes: 0"
if [ $? -eq 0 ]; then
  echo 'killing deluge daemon'
  pkill deluged
  exit 1
fi