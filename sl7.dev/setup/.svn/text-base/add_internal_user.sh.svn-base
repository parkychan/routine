#!/bin/bash

if [ $# != 3 ]
then
  echo "Usage $0 <user> <shadow pw> <host file>"
  exit 1
fi

user=$1
pw=`echo $2 | sed -r 's/\\\$/\\\\$/g'`
host_file=$3

for i in `cat $host_file`
do 
  echo !!!!!!!!! $i
  c=`ssh -t $i sudo cat /etc/shadow | grep -c '^'$user':'`
  if [ $c -eq 0 ]
  then
    echo "add user $user to $i..."
    # if user not exist yet, add user first
    ssh -o StrictHostKeyChecking=no -t $i sudo /usr/sbin/adduser -G virality $user
  fi
  # change password
  tmp_shadow=/tmp/shadow.$$
  # removed sed 's!^M!!' from the end...
  ssh -t $i sudo sed 's%^'$user':[^:]*%'$user':'$pw'%' /etc/shadow | sed 's!\r$!!' > $tmp_shadow
  # check if root & virality is in the shadow
  rcnt=`cat $tmp_shadow | grep -c '^root:'`
  vcnt=`cat $tmp_shadow | grep -c '^virality:'`
  ucnt=`cat $tmp_shadow | grep -c '^'$user':'`
  if [ $rcnt -eq 1 -a $vcnt -eq 1 -a $ucnt -eq 1 ]
  then
    echo "update shadow to $i."
    scp $tmp_shadow $i:$tmp_shadow
    rm $tmp_shadow
    ssh -t $i sudo cp $tmp_shadow /etc/shadow
    ssh -t $i sudo rm $tmp_shadow
  else
    echo "ERROR: missing root, virality or $user in $tmp_shadow. file not copied to $i." 
  fi
done
