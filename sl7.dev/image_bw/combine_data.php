<?php
$date = $argv[1];
if (!preg_match('/^\d{8}$/', $date)) {
  echo "date must be of format YYYYMMDD\n";
  exit;
}

$dbhost = '10.21.8.135';
$dbuser = 'virality';
$dbpass = '25800115';
$dbname = 'reporting';

$mysqli = new mysqli($dbhost, $dbuser, $dbpass, $dbname);
$mysqli->set_charset('utf8');
$domain_bw = array();

$h = popen("cat /tmp/image_bw_*-$date.txt", "r");
while (!feof($h)) {
  $line = fgets($h);
  if (preg_match("/^d:(\S+)\t(\d+)/", $line, $matches)) {
    $domain = $mysqli->real_escape_string($matches[1]);
    $bytes = $matches[2];
    $domain_bw[$domain] += $bytes;
  }
}
pclose($h);

foreach ($domain_bw as $domain => $bytes) {
  $sql = "REPLACE INTO domain_bandwidth (date, domain, bytes) VALUES ('$date', '$domain', $bytes)";
  if (!$mysqli->real_query($sql)) {
    echo $mysqli->error."\n";
  }
}

?>