#!/bin/bash

if [ $# -lt 2 ]
then
  echo "Usage $0 <user> <host file> <confirm>"
  echo "  type confirm at the end to really del the user"
  exit 1
fi

user=$1
host_file=$2
confirm=''
if [ $# -gt 2 ]
then
  confirm=$3;
fi

if [ $confirm'x' != 'confirmx' ]
then
  echo "##### DRYRUN ONLY: type confirm at the end to really del the user"
fi

for i in `cat $host_file`
do 
  c=`ssh -t $i sudo cat /etc/shadow | grep -c '^'$user':'`
  if [ $c -gt 0 ]
  then
    echo "delete user $user on $i..."
    # if user not exist yet, add user first
    if [ $confirm'x' = 'confirmx' ]
    then
#      echo 'confirm'
      ssh -o StrictHostKeyChecking=no -t $i sudo /usr/sbin/userdel $user
    fi
  else 
    echo "user $user not exists..."
  fi
done
