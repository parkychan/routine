#!/bin/bash

cd `dirname $0`
date=`date -d yesterday +%Y%m%d`
./bwdump -c > /home/virality/image_bw/logs/$date.txt
