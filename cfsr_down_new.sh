#!/bin/bash
# update_cfsr4wrf.sh
# Author: Lifeng Luo (lluo@msu.edu)
# Revision: 2011-08-28
# Description: download version 2 of the CFSR4WRF data, or update it from version 1
# Required Packages: wgrib2, wget
# wgrib2 is available from http://www.cpc.ncep.noaa.gov/products/wesley/wgrib2/
#========================================================
#
# MAKE SURE YOUR DIRECTORY FOLLOWS THIS STRUCTURE
# $yyyy/$yyyy$mm/$yyyy$mm$dd
#
#========================================================

#define your local path for data and tools
local_path=/disk11/yagnesh/cfsr_new/
wgrib2=/home/yagnesh/local/bin/wgrib2

#########################################################
#  NO NEED TO CHANGE THINGS BELOW
########################################################
function usage() {
    echo "USAGE: $1 startdate enddate"
    echo "EG: $1 1980010100 1980010106"
}

if [ $# -lt 2  ]; then
    usage $0
    exit $wrong_arg
fi

wrong_arg=64
sdate_len=10                    #  arguments length (yyyymmddhh)

sdate=$1
edate=$2

echo "sdate: " $sdate  "edate: " $edate

# check if the sdate/edate are okay (not foolproof just checks the length)
[ ${#sdate} -eq $sdate_len -a ${#edate} -eq $sdate_len ] ||
exit $wrong_arg

remote_host=http://drought.geo.msu.edu
remote_path=data/CFSR4WRF/data
cfsrprefix=CFSR_
newsuffix=grib2

# set -x
logfile=$local_path/log.$$

date=$sdate
while [ $date -le $edate ]
do
    echo "working with $date"

    yyyy=`echo $date |cut -c1-4`
    mm=`echo $date |cut -c5-6`
    dd=`echo $date |cut -c7-8`
    hh=`echo $date |cut -c9-10`
    local_dir=$local_path/$yyyy/$yyyy$mm/$yyyy$mm$dd
    mkdir -p $local_dir
    cd $local_dir

    fname=${cfsrprefix}$yyyy$mm$dd$hh.$newsuffix

    if [ ! -f $fname ]; then

        echo "downloading $fname directly"
        wget -c -np -nH -nc $remote_host/$remote_path/$yyyy/$yyyy$mm/$yyyy$mm$dd/${cfsrprefix}$yyyy$mm$dd$hh.$newsuffix
        [ $? -ne 0 ] && echo "$fname" >> $logfile

    fi
    datestring="$yyyy-$mm-$dd $hh:00:00"
    date=`date -u +"%Y%m%d%H" -d "+6 hours $datestring"`
done

# End of script
#-------------------
