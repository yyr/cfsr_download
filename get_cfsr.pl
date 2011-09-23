#!/usr/bin/env perl
#
# Copyright (C) Yagnesh Raghava Yakkala. www.yagnesh.org
#    File: get_cfsr.pl
#  Author: Yagnesh Raghava Yakkala <yagnesh@live.com>
# Created: Wednesday, June 22 2011
#

# Description:
# Get the CFSR data

use strict;
use warnings;
use Date::Calc qw/Days_in_Month/;

# User Changes
# http://drought.geo.msu.edu/data/CFSR4WRF/data/2011/201106/20110621/CFSR_2011062100.grb2

my $url_head = "http://drought.geo.msu.edu/data/CFSR4WRF/data";
my @year;
my @month= ('01','02','03','04','05','06','07','08','09','10','11','12');
my $data_file;

# --------------------------------
sub wget_down {
  my ($url) = @_;
  my $er_log_file = "log.error.$$";
  print "started downloading.. $url\n";
  my $er_code = system("wget","-c","--timeout=90","$url");
  if ($er_code != 0 ) {
    open(my $fh_e, ">>",$er_log_file) or die "cant open logfile $!";
    print $fh_e  "$url\n";        # put in log for later downloading
  } else {
    print "finished downloading.. $url\n";
  }
}

# body ---------------
foreach my $y (@year) {
  foreach my $m (@month) {
    foreach my $d (1 .. Days_in_Month($y,$m)) {
      if ($d < 10) {
        $d="0$d";
      }
      foreach my $t ('00','06','12','18') {
	# here is the patch
        $data_file="CFSR_$y$m$d$t.grb2";
        if (-e "$data_file" ) {
          print "$data_file is already Downloaded\n";
        } else {
          wget_down("$url_head/$y/$y$m/$y$m$d/CFSR_$y$m$d$t.grb2");
        }
	# here is the patch
      }
    }
  }
}

# get_cfsr.pl ends here
