#!/bin/bash
#
# Copyright (C) Yagnesh Raghava Yakkala. http://yagnesh.org
#    File: moving.sh
#  Author: Yagnesh Raghava Yakkala <yagnesh@NOSPAM.live.com>
# Created: Monday, September 26 2011
# License: GPL v3 or later.  <http://www.gnu.org/licenses/gpl.html>
#

# Description:
sdate=1980010100
edate=1980010106

#define your local path for data and tools
local_path=./
wgrib2=/usr/local/bin/wgrib2
delete_old=NO

echo "Please make sure your data were saved in the following structure
      $local_path/\$yyyy/\$yyyy\$mm/\$yyyy\$mm\$dd/
      then comment out line 23-26 in the script to excute it again"

exit

#########################################################
#  NO NEED TO CHANGE THINGS BELOW
########################################################
remote_host=http://drought.geo.msu.edu
remote_path=data/CFSR4WRF/data
cfsrprefix=CFSR_
oldsuffix=grb2
newsuffix=grib2

set -x

date=$sdate
while [ $date -le $edate ]
do
    yyyy=`echo $date |cut -c1-4`
    mm=`echo $date |cut -c5-6`
    dd=`echo $date |cut -c7-8`
    hh=`echo $date |cut -c9-10`
    local_dir=$local_path/$yyyy/$yyyy$mm/$yyyy$mm$dd
    mkdir -p $local_dir
#    cd $local_dir


    datestring="$yyyy-$mm-$dd $hh:00:00"
    date=`date -u +"%Y%m%d%H" -d "+6 hours $datestring"`
done

# End of script
#-------------------


# moving.sh ends here
