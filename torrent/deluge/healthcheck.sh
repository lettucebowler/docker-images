#!/bin/sh
pkill deluge-console
deluge-console --username user --password pass status | grep "^DHT Nodes: 0$"
if [ $? -eq 0 ]; then
  echo 'killing deluge daemon'
  pkill deluged
  exit 1
fi