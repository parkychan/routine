#!/bin/sh

sudo /etc/init.d/fail2ban stop
sudo /sbin/iptables-restore < /tmp/ip
sudo /sbin/service iptables save
sudo /etc/init.d/fail2ban start
rm /tmp/deploy_iptables.sh
