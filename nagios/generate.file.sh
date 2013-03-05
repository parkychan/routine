#!/bin/bash


for i in `cat game.name`; do
if [ "$i" != "goddamn" ]; then

grep $i  hosts.sort >> temp/$i 

echo $i >> hosts.no6w

fi

done


