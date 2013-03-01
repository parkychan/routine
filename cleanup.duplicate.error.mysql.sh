#!/bin/bash

while [ 1 ]; do if [ `mysql -e "show slave status\G" | grep "Duplicate entry" | wc -l` -eq 1 ]; then mysqladmin stop-slave; mysql -e “set global sql_slave_skip_counter=1″; mysqladmin start-slave; fi; sleep 7; done
