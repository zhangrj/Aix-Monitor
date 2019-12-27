#!/bin/sh

valp=`lsps -s | tail -1 | awk '{print $2}' | cut -d "%" -f1`
echo $valp