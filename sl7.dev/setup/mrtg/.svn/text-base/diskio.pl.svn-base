#!/usr/bin/perl -w
#
# Version	0.1
# Creator	cosmos@6waves.com
# Date Created	12 Jul 2010
# Last Modified	12 Jul 2010
#
# Sum up disk IO of all block device.  Will skip IO of partition (sda1, sda2, etc.) if a
# summary reading present (sda, etc.)

my @info;
my %reading;
my %dev_list;
my ($dev,$dev_parent,$r,$w);
my $i;

open IOSTAT, "/usr/bin/iostat -dk |";

while ( <IOSTAT> ){
  if ( /^\wd\w\d?/ ){
    chomp;
    @info=split /  */;
    ($dev,$r,$w)=@info[0,4,5];
    $dev_parent=substr($dev,0,3);

    $reading{$dev}=[$r,$w];

    if ( $dev_parent eq $dev ){
      $dev_list{$dev_parent}=\$dev_parent;
    }else{
      if ( ! defined $dev_list{$dev_parent} ){
        $dev_list{$dev_parent}=[$dev];
      }elsif ( 'ARRAY' eq ref($dev_list{$dev_parent}) ){
	push @{$dev_list{$dev_parent}},$dev;
      }
    }
  }
}

$r=0;
$w=0;

while ( ($dev_parent,$dev) = each %dev_list ){
  if ( ref($dev) eq 'SCALAR' ){
    $r += $reading{$dev_parent}->[0];
    $w += $reading{$dev_parent}->[1];
  }elsif ( ref($dev) eq 'ARRAY' ){
    foreach $i ( @$dev ){
      $r += $reading{$i}->[0];
      $w += $reading{$i}->[1];
    }
  }
}

print "$r\n$w\n\n";
if ( defined $ENV{'HOSTNAME'} ){
  print "$ENV{'HOSTNAME'}\n";
}else{
  print "\n";
}

