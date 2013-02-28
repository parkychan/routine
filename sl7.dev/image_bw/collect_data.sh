#!/bin/bash

cd `dirname $0`

IMAGE_BW_DIR=/home/virality/image_bw
date=`date -d yesterday +%Y%m%d`

for i in `cat image_servers.txt`;
do
  scp -o StrictHostKeyChecking=no $i:$IMAGE_BW_DIR/logs/$date.txt /tmp/image_bw_$i-$date.txt
done

php ./combine_data.php $date

rm /tmp/image_bw_*.txt
