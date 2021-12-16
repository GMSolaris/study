#!/usr/bin/env bash

LOGFILE="scripts.log"
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`

list=$1
iterations=$2
readarray -t server_list < $list


function check_state 
{
	for (( i=0;  i < ${#server_list[*]} ; i++ ))
	do
	state=$(nc -z -v -w2 ${server_list[$i]} 80 2>&1)
	echo "$TIMESTAMP $state" >> $LOGFILE
	done
}

for (( i2=0; i2 < iterations; i2++ ))
do
check_state
done
exit 0


