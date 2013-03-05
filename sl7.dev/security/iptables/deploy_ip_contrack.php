<?php

## This script is used to confirm that we can process the list of servers 
## without any login or sudo problems before we run any deployment

## this is used when you see logs like this in /var/log/messages
## Jun 20 04:08:00 xsell1 kernel: ip_conntrack: table full, dropping packet.

$hosts = explode ("\n", `cat do-list`);
#$hosts = array ( "w1.payment.6waves.com" );

foreach ($hosts as $host ) {
if ($host == "" ) continue;
#if ($host == "sl7.6waves.com" ) continue;
	echo "=====> $host start...\n";
	echo `ssh -t $host "sudo /sbin/sysctl -w net.ipv4.netfilter.ip_conntrack_tcp_timeout_established=1800;sudo /sbin/sysctl -w net.ipv4.netfilter.ip_conntrack_max=131072"`;
	echo "=====> $host done...\n";
}

?>
