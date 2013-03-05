#!/usr/bin/perl -w
#
# procstats.pl - a simple program to generate MRTG-type output from
#                /proc/stats on Linux systems.  Copyright 2001,
#                FibreSpeed and licensed under the GPL version 2.
# Authored by Michael T. Babcock <mbabcock-code@fibrespeed.net>

use Getopt::Std;

# Specified on command-line:
$lookfor = "page";

use vars qw($opt_h $opt_p $opt_s);
getopts('hps');

$lookfor = "page" if ($opt_p);
$lookfor = "swap" if ($opt_s);

if ($opt_h) {
	print "-s for swap stats\n";
	print "-p for disk page stats\n";
	exit(0);
}

#################
# Data collection
#

open (PROC, "< /proc/stat");
while (<PROC>) {
	if (/swap (\d+) (\d+)/) {
		$swapin = $1;
		$swapout = $2;
	}
	if (/page (\d+) (\d+)/) {
		$pagein = $1;
		$pageout = $2;
	}
}
close PROC;

if [ -z $swapin ]; then
swapin=`cat /proc/vmstat | grep pswpin | cut -d' ' -f 2`
swapout=`cat /proc/vmstat | grep pswpout | cut -d' ' -f 2`
fi

# Output MRTG-style data
$lookfor eq "swap" and print "$swapin\n$swapout\nunused\nunused\n";
$lookfor eq "page" and print "$pagein\n$pageout\nunused\nunused\n";


