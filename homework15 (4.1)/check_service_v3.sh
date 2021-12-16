#!/usr/bin/env bash

LOGFILE="scripts.log"
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`

list=$1
readarray -t server_list < $list


function check_state 
{
	for (( i=0;  i < ${#server_list[*]} ; i++ ))
	do
	state=$(nc -z -v -w2 ${server_list[$i]} 80 2>&1 | grep 'succeeded' | wc -l)
	if [[ $state -eq "0" ]] 
		then
			echo "$TIMESTAMP ${server_list[$i]} check state failed" >> $LOGFILE
			break
	fi
	done
}

while ((1==1))
do
	check_state
	if [[ $state -eq "0" ]] 
		then 
		break
	fi
done
exit 0

