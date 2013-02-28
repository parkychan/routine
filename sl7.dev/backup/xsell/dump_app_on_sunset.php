<?php

$dbhost = "10.21.240.77"; // db4

$appid = $argv[1];

if ( empty($appid) ) { error_log ( "No appid"); exit; }

$sqls['user_app_install'] = "user_app_install where appid='$appid'";
$sqls['user_app_access'] = "user_app_access where appid='$appid'";
$sqls['user_demog'] = "user_demog where from_app='$appid'";
#$sqls['user_class_access'] = "user_class_access where appid='$appid'";
$sqls['app_synergy'] = "app_synergy where app1='$appid' or app2='$appid'";
$sqls['app_country_au'] = "app_country_au where appid='$appid'"; // no index
$sqls['xsell_clicks2'] = "xsell_clicks2 where source_appid='$appid' or target_appid='$appid'"; // no index
$sqls['user_emails'] = "user_emails where appid='$appid'";
$sqls['xsell_impressions'] = "xsell_impressions where source_appid='$appid' or target_appid='$appid'";
$sqls['app_user_count'] = "app_user_count where appid='$appid'";

// @todo ads system

$dir = "/tmp/xsell_backup_$appid";
`mkdir $dir`;

foreach ( $sqls as $table => $sql ) {
	error_log ( "Dumping $table..." );
	$sql = "select * from $sql";
	$cmd = "mysql -uvirality -p25800115 -h$dbhost -e \"$sql\" xsell";
	`$cmd > $dir/$table`;
}

`cd /tmp;tar -zcf xsell_backup_$appid.tgz /tmp/xsell_backup_$appid;rm -r $dir`;

?>
