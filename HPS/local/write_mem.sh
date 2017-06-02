#!/bin/bash

set -eu

INIT_VAL=0x20000000

start_time=$(date +%s%N)
for r in {1..5}; do
    echo "[${start_time}] Start Round ${r}"

    val=${INIT_VAL}
    for i in {0..1023}; do
        while true; do
	    origVal=`./memtool -32 ${val} 1`
            if [[ ${origVal} == *"  00000000"* ]]; then
                 ./memtool -32 `echo ${val}`=0xaabbcc > /dev/null
                 val=`printf '0x%x\n' $((val+4))`
                 break
            fi
        done
    done
done

while true
do
    val=`./memtool -32 0x20000000 1`
    if [[ $val == *"  00000000"* ]]; then
        end_time=$(date +%s%N)
        echo -e "\nTime duration: $(((end_time-start_time)/1000000))"
        break
    fi
done
