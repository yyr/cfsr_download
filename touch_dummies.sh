#!/bin/bash
#
# Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
#    File: touch_dummies.sh
#  Author: Yagnesh Raghava Yakkala <yagnesh@NOSPAM.live.com>
# Created: Monday, September 26 2011
# License: GPL v3 or later.  <http://www.gnu.org/licenses/gpl.html>
#

# Description:
sdate=2000010100
edate=2002010200

local_path=./
cfsrprefix=CFSR_
suffix=grb2

# ----------------------------------
date=$sdate
while [ $date -le $edate ]
do
    yyyy=`echo $date |cut -c1-4`
    mm=`echo $date |cut -c5-6`
    dd=`echo $date |cut -c7-8`
    hh=`echo $date |cut -c9-10`
    local_dir=$local_path/$yyyy/$yyyy$mm/$yyyy$mm$dd
    # mkdir -p $local_dir

    touch $cfsrprefix$yyyy$mm$dd$hh.$suffix

    datestring="$yyyy-$mm-$dd $hh:00:00"
    date=`date -u +"%Y%m%d%H" -d "+6 hours $datestring"`
done

# touch_dummies.sh ends here
