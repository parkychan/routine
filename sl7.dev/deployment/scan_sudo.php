<?php

## This script is used to confirm that we can process the list of servers 
## without any login or sudo problems before we run any deployment

$hosts = explode ("\n", `cat do-list`);

foreach ($hosts as $host ) {
if ($host == "" ) continue;
if ($host == "sl7.6waves.com" ) continue;
	echo "=====> $host start...\n";
	echo `ssh -t $host sudo ls /`;
	echo "=====> $host done...\n";
}

?>
