#!/bin/bash

if [ $# lt 1 ]
then
  echo "Usage: $0 host [time]"
  exit
fi

host=$1
time=${2:-23:00}

echo "GRANT RELOAD,SUPER,REPLICATION CLIENT ON *.* TO virality@localhost;" | ssh $host mysql -uroot
scp MySQL-zrm-2.2.0-1.noarch.rpm mysql-zrm.conf $host:.
ssh -t $host sudo yum localinstall MySQL-zrm-2.2.0-1.noarch.rpm
ssh -t $host sudo mkdir /etc/mysql-zrm/dailyrun
ssh -t $host sudo cp mysql-zrm.conf /etc/mysql-zrm/dailyrun
ssh -t $host sudo chown -R mysql.mysql /etc/mysql-zrm
ssh -t $host sudo -u mysql mysql-zrm-backup --backup-set dailyrun
if [ $? = 0 ]
then
  ssh -t $host sudo -u mysql mysql-zrm-scheduler --add --interval daily --start $time --backup-level 0 --backup-set dailyrun
  ssh -t $host sudo -u mysql mysql-zrm-scheduler --query
else 
  echo "backup setup has errors.  please fix the error and manually run mysql-zrm-scheduler on the db server"
  exit 1
fi
