#!/bin/ksh

iowait_list=$(/usr/bin/vmstat 1 4 | egrep -v '[a-z,A-Z]|-' |egrep '[0-9]' | awk {'print $17'})

count=0

for iowait in $iowait_list
do
    count=`expr $count + $iowait` 
done

cpu_iowait=`expr $count / 4`

echo $cpu_iowait