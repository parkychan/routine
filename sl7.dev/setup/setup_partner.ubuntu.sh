#!/bin/bash

SSH="ssh -o StrictHostKeyChecking=no"
if [ `whoami` != 'root' ]
then
  echo "must be run by root!"
  exit 1
fi

if [ $# != 1 ]
then
  echo "Usage $0 <host>"
  exit 1
fi

echo "pls enter the domain name of the host"

read ho

echo "Which dataceneter of this machine"
echo "1) SoftLayer"
echo "2) AWS"
echo "3) Peer1"
echo "4) rimu"
echo "5) rackspace"

read sno

case  $sno in 

1) 
echo  $ho  >> ../deployment/sl-list 
;;

2) 
echo  $ho  >> ../deployment/aws-list

;;
3)
echo  $ho  >> ../deployment/peer1-list
;;
4)
echo  $ho  >> ../deployment/rimu-list
;;
5)
echo  $ho  >> ../deployment/rackspace-list
esac



read -p "is this a 6w machine (Y/N): " yn

if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
        echo "OK, continue"
	echo $ho >> ../deployment/6w-list

elif [ "$yn" == "N" ] || [ "$yn" == "n" ]; then
        echo "Oh, interrupt!"
else
        echo "script will be exist " && exit 0
fi







host=$1;






read -p "is this a CENTOS O.S: (y/n)  " yn

if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
        echo "OK, continue"
  grep -E 'virality|terry|tony|cblee|aboy|steve' /etc/shadow > /tmp/shadow
tar -C /etc -cf /tmp/mrtg.tar mrtg
tar -C /home/virality -cf /tmp/virality.tar .ssh/authorized_keys .vimrc .bashrc .bash_profile
# for root password, please check from softlayer
scp /tmp/shadow setup_partner_helper.sh nrpe.cfg check_conntrack.sh /tmp/mrtg.tar /tmp/virality.tar ../security/iptables/ip ../security/fail2ban/jail.conf  root@$host:.
#scp /tmp/shadow setup_partner_helper.sh nrpe.cfg check_conntrack.sh /tmp/mrtg.tar /tmp/virality.tar ../security/iptables/ip ../security/fail2ban/jail.conf  ../security/denyhosts/denyhosts.conf   ../security/denyhosts/hosts.allow   root@$host:.
$SSH root@$host sh setup_partner_helper.sh
$SSH -t root@$host rm setup_partner_helper.sh
$SSH -t root@$host "sysctl -w kernel.hostname=$ho"

  
else
grep -E 'virality|terry|tony|cblee|steve' /etc/shadow > /tmp/shadow
tar -C /etc -cf /tmp/mrtg.tar mrtg
tar -C /home/virality -cf /tmp/virality.tar .ssh/authorized_keys .vimrc .bashrc .bash_profile
# for root password, please check from softlayer
scp /tmp/shadow setup_partner_helper.ubuntu.sh  nrpe.cfg check_conntrack.sh ../security/iptables/ip  /tmp/mrtg.tar /tmp/virality.tar ../security/denyhosts/denyhosts.conf   ../security/denyhosts/hosts.allow root@$host:.
$SSH root@$host sh setup_partner_helper.ubuntu.sh
$SSH -t root@$host rm setup_partner_helper.ubuntu.sh
$SSH -t root@$host "sysctl -w kernel.hostname=$ho"
#$SSH root@$host rm /root/*

fi

