#!/bin/ksh

cpu_idle_list=$(/usr/bin/vmstat 1 4 | egrep -v '[a-z,A-Z]|-' |egrep '[0-9]' | awk {'print $16'})

count=0

for cpu_idle in $cpu_idle_list
do
    count=`expr $count + $cpu_idle` 
done

cpu_used=`expr 100 - $count / 4`

echo $cpu_used