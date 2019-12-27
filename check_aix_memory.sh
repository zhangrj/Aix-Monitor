#!/bin/ksh

um=`svmon -G | head -2|tail -1| awk {'print $3'}`
um=`expr $um / 256`
tm=`lsattr -El sys0 -a realmem | awk {'print $2'}`
tm=`expr $tm / 1000`
fm=`expr $tm - $um`
pa=`echo "scale=2;  $um/$tm" | bc`
pr=`echo "scale=0;  $pa * 100" | bc`
PERCENTUSED=$pr

echo $PERCENTUSED
exit 0