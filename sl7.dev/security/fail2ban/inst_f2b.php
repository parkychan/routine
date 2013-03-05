<?php

$hosts = explode ("\n", `cat do-list`);
/*
$hosts = array (
	"urchin1.6waves.com",
	#"app3.6waves.com",
	#"sl19.6waves.com",
	#"w1.6waves.com",
	#"sl7.6waves.com",
);
*/

foreach ($hosts as $host ) {
if ( $host == "" ) exit;
        echo "=====> $host start...\n";
		echo `sudo -u virality ./inst_f2b.sh $host`;
        echo "=====> $host done...\n";
}

?>
