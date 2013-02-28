<?php

$file = $argv[1];
$content = explode ( "\n", trim(`cat $file`) );

function sort_from_behind ( $a, $b ) {
	$a = str_replace(".6waves.com","",$a);
	$b = str_replace(".6waves.com","",$b);
	if ( strpos ( $a, "." ) !== false && strpos($b, ".") !== false ) {
		$a = join(".", array_reverse(explode (".",$a)));
		$b = join(".", array_reverse(explode (".",$b)));
		return $a > $b;
	}
	if ( strpos ( $a, "." ) !== false ) {
		return -1;
	}
	if ( strpos ( $b, "." ) !== false ) {
		return 1;
	}
	return $a > $b;
}

usort ( $content, "sort_from_behind" );

echo join("\n",$content);

?>
