#!/bin/bash

# Check de nagios para monitorizar el numero de conexiones establecidas 
# nablas@gmail.com
#
# Version history
#
# 0.1:  First release
# 0.2:  The path /proc/sys/net/ipv4/netfilter/ip_conntrack_count may be 
#	differtent in each distribution, so now the script search for it.
#        



# Ayuda ##############################################
if [ $# != 2 ]; then
	echo "Syntax: check_conntrack <warn percent> <crit percent>"
	echo 
	echo "Example: check_conntrack 75 90"
	exit -1
fi


# Busqueda de archivos ###############################
COUNT_FILE=`find /proc/sys -name *conntrack_count | head -n 1`
MAX_FILE=`find /proc/sys -name *conntrack_max | head -n 1`
if [ -z $MAX_FILE ] || [ -z $COUNT_FILE ]; then
	echo "ERROR - No se han encontrado los archivos"
	exit -1
fi


# Calculo de valores #################################
COUNT=`cat $COUNT_FILE | head -n 1`
MAX=`cat $MAX_FILE | head -n 1 `
WARN=`expr $MAX \* $1 \/ 100`
CRIT=`expr $MAX \* $2 \/ 100`


# Evaluacion #########################################
if [ `expr $COUNT \< $WARN` == `expr $COUNT \> 0` ]; then
        echo "OK - $COUNT |con=$COUNT"
        exit 0

fi

if [ `expr $COUNT \< $CRIT` == `expr $COUNT \> $WARN`  ]; then
        echo "WARNING - $COUNT |con=$COUNT"
        exit 1
fi

if [ `expr $COUNT \> $CRIT` ]; then
        echo "CRITICAL - $COUNT |con=$COUNT"
        exit 2
fi

echo "UNKNOWN - Error inesperado"
exit -1

