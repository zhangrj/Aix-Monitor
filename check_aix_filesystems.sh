#!/bin/ksh

# Global Variables
count=0
output=""
output_ext="<br/>当前磁盘空前使用情况总览<br/>"
# Default type is the grep pattern jfs (also matches jfs2 etc.)
mountType=""

errorHelp() {
   echo "----- ERROR -----"
   echo "- Dude! You have to pass arguments to the script, for it to work."
   echo "- Example of usage:"
   echo "       ./check_filesystems_space 90 99 \"jfs\"," 
   echo "        for warning 90 and critical 99 and only include filesystems types that matches the pattern 'jfs'
 (default)."
   echo "-----------------"
   exit
}

# Argument Checking
if [[ $# -eq 2 ]] ;then
    mountType="jfs|vxfs"
elif [[ $# -eq 3 ]]; then
    mountType=$3
else
    errorHelp
fi
        
# Iteration of file systems.
if [ -n "$1" ] && [ -n "$2" ] && [ -n "$mountType" ]
then
        warninglimit=$2
        lowlimit=$1
        rawSysVDFResults=`/usr/sysv/bin/df -n | grep -i -E $mountType | awk -F\: '{print ""$1":"$2""}' | tr -d '\t' | tr -d ' '`

        for fs in $rawSysVDFResults
        do
                set -A array $(echo $fs | tr ':' '\n')
                fMount=${array[0]}  
                fType=${array[1]}   

                size=`df -k $fMount|grep $fMount|awk '{ print $4; }'`
                prc=`echo $size | tr -d "%"`
                output_ext=${output_ext}"$fMount $size;<br/>"
                if [ $prc -gt $warninglimit ]
                then
                        output=`echo $output "CRITICAL: $fMount 使用率 $size;"`
                        count=`expr $count + 1`
                elif [ $prc -gt $lowlimit ]
                then
                        output=`echo $output "WARNING: $fMount 使用率 $size;"`
                        count=`expr $count + 1`
                fi
        done
fi

#output
if [ $count -gt 0 ] 
then
        echo $output
else
        if [ -n "$1" ] && [ -n "$2" ] && [ -n "$mountType" ]
        then
                echo "OK: Filesystem space inside acceptable levels"
        fi
fi 
echo $output_ext
