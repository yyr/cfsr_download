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
local_path=/disk11/yagnesh/cfsr/
wgrib2=/home/yagnesh/local/bin/wgrib2
delete_old=NO

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
oldsuffix=grb2
newsuffix=grib2

# set -x

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
    fresh=NO

    if [ ! -f ${cfsrprefix}$yyyy$mm$dd$hh.$newsuffix ]; then

#check if you have the version 1 of the data
        if [ ! -f ${cfsrprefix}$yyyy$mm$dd$hh.$oldsuffix ]; then
            fresh=YES
        else

#check integrity of the data
            nline=`$wgrib2 ${cfsrprefix}$yyyy$mm$dd$hh.$oldsuffix |wc -l`
            [ $? -ne 0 ] && fresh=YES
            [ $nline -ne 206 ] && fresh=YES
        fi

        if [ "$fresh" = "YES" ]; then
            echo "download version 2 directly"
            wget -c -np -nH -nc $remote_host/$remote_path/$yyyy/$yyyy$mm/$yyyy$mm$dd/${cfsrprefix}$yyyy$mm$dd$hh.$newsuffix
            [ $? -ne 0 ] && exit 9
        else

            echo "Version 1 data exist, download updates only!"
#check flxf06 and hgtsfc files
            if [ ! -f flxf06_$yyyy$mm$dd$hh.$newsuffix ]; then
                wget -c -np -nH -nc $remote_host/$remote_path/$yyyy/$yyyy$mm/$yyyy$mm$dd/flxf06_$yyyy$mm$dd$hh.$newsuffix
                [ $? -ne 0 ] && exit 9
            fi

            if [ ! -f hgtsfc_$yyyy$mm$dd$hh.$newsuffix ]; then
                wget -c -np -nH -nc $remote_host/$remote_path/$yyyy/$yyyy$mm/$yyyy$mm$dd/hgtsfc_$yyyy$mm$dd$hh.$newsuffix
                [ $? -ne 0 ] && exit 9
            fi

            $wgrib2 ${cfsrprefix}$yyyy$mm$dd$hh.$oldsuffix -for 1:150 -ncep_uv a.$newsuffix > /dev/null
            [ $? -ne 0 ] && exit 9

            cat a.$newsuffix hgtsfc_$yyyy$mm$dd$hh.$newsuffix flxf06_$yyyy$mm$dd$hh.$newsuffix  \
                > ${cfsrprefix}$yyyy$mm$dd$hh.$newsuffix
            $wgrib2 $cfsrprefix$yyyy$mm$dd$hh.$newsuffix > $cfsrprefix$yyyy$mm$dd$hh.$newsuffix.inv

            if [ $? -eq 0 ] && [ "$delete_old" = "YES" ]; then
                rm -f a.$newsuffix $cfsrprefix$yyyy$mm$dd$hh.$oldsuffix*
            fi
        fi
    fi
    datestring="$yyyy-$mm-$dd $hh:00:00"
    date=`date -u +"%Y%m%d%H" -d "+6 hours $datestring"`
done

# End of script
#-------------------
