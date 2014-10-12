#!/bin/bash

#
# AUTHOR: Yanpeng Lin
# DATE:   Mar 30 2014
# DESC:   lock a rotating file(static filename) and tail
#

PID=$( mktemp )
while true;
do
    CURRENT_TARGET=$( eval "echo $1" )
    # echo $CURRENT_TARGET
    if [ -e ${CURRENT_TARGET} ]; then
        IO=`stat -c %i ${CURRENT_TARGET}`
        tail -f {$CURRENT_TARGET} 2> /dev/null & echo $! > $PID;
    fi
    
    # as long as the file exists and the inode number did not change
    while [[ -e ${CURRENT_TARGET} ]] && [[ ${IO} = `stat -c %i ${CURRENT_TARGET}` ]]
    do
        CURRENT_TARGET=$( eval "echo $1" )
        #echo $CURRENT_TARGET
        sleep 0.5
    done
    # echo "[ ! -z $PID ] && kill `cat $PID` 2> /dev/null && echo > $PID"
    if [ ! -z ${PID} ]; then
        kill `cat ${PID}` 2> /dev/null && echo > ${PID}
    fi
    sleep 0.5
done 2> /dev/null
rm -rf ${PID}
