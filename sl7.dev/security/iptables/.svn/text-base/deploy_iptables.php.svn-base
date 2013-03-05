<?php

$hosts = explode ("\n", `cat do-list`);
#$hosts = array("urchin1.6waves.com");

foreach ($hosts as $host ) {
    if ($host == "" ) continue;
    if ($host == "sl7.6waves.com" ) continue;
	echo "\n============================\n";
	echo "=====> $host start...\n";
	echo "============================\n";
	echo `scp -q ip deploy_iptables.sh $host:/tmp/`;
	echo `ssh -t $host "sudo chmod 700 /tmp/deploy_iptables.sh;sudo chown root:root /tmp/deploy_iptables.sh;sudo /tmp/deploy_iptables.sh"`;
}

?>
