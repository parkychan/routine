#!/bin/bash

SSH="ssh -o StrictHostKeyChecking=no -i ~/parky"
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

if [[ $host == *harvest* ]]
then
  copy_from=db1.harvest.6waves.com
elif [[ $host == *fish* ]]
then
  copy_from=m1.fish.6waves.com
elif [[ $host == *.ap.* ]]
then
  copy_from=w1.ap.6waves.com
elif [[ $host == *.pet.* ]]
then
  copy_from=w1.pet.6waves.com
fi

if [ "$copy_from" != "" ]
then
  # removed sed 's/^M//'
  $SSH -i /home/virality/.ssh/id_rsa -t virality@$copy_from "sudo grep -E 'virality|terry|tony|cblee|steve' /etc/shadow" | sed 's/\r$//' > /tmp/shadow
else
  grep -E 'virality|terry|tony|cblee|steve' /etc/shadow > /tmp/shadow
fi

tar -C /etc -cf /tmp/mrtg.tar mrtg
tar -C /home/virality -cf /tmp/virality.tar .ssh/authorized_keys .vimrc .bashrc .bash_profile
# for root password, please check from softlayer
scp /tmp/shadow setup_partner_helper.sh nrpe.cfg check_conntrack.sh /tmp/mrtg.tar /tmp/virality.tar ../security/iptables/ip ../security/fail2ban/jail.conf  root@$host:.
#scp /tmp/shadow setup_partner_helper.sh nrpe.cfg check_conntrack.sh /tmp/mrtg.tar /tmp/virality.tar ../security/iptables/ip ../security/fail2ban/jail.conf  ../security/denyhosts/denyhosts.conf   ../security/denyhosts/hosts.allow   root@$host:.
$SSH root@$host sh setup_partner_helper.sh
$SSH -t root@$host rm setup_partner_helper.sh
$SSH -t root@$host "sysctl -w kernel.hostname=$ho"




#new added
#read -p "Create NAGIOS and MRTG (Y/N): " yn


#if [ "$yn" == "Y" ] || [ "$yn" == "y" ]; then
#        echo "OK, continue"
#
#        sudo sh monitor.sh

#elif [ "$yn" == "N" ] || [ "$yn" == "n" ]; then
#        echo "Oh, interrupt!"
#else
#        echo "script will be exist " && exit 0
#fi


