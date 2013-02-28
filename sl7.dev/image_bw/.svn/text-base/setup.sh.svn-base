#!/bin/bash

servers=`cat image_servers.txt`
for server in $servers
do
  sudo -u virality ssh $server mkdir -p /home/virality/image_bw/bin /home/virality/image_bw/logs /home/virality/image_bw/db
  sudo -u virality scp lighttpd.conf $server:
  sudo -u virality ssh -t $server sudo cp lighttpd.conf /etc/lighttpd/lighttpd.conf
done
make ppush

for server in $servers
do
  sudo -u virality ssh -t $server sudo /etc/init.d/lighttpd restart
done
