#!/bin/bash


RUN_NUM=$1
RADIUS=$2
RELOCATION=$3
SPACE=$4
TYPE=$5
SD=$6
SIM_DIR=$7
WAF_DIR=$8
FOLDER_NAME=$9
TIME_FILE="$FOLDER_NAME/RUNTIME.txt"


echo "/usr/bin/time -o $TIME_FILE -a -f \"run $RUN_NUM - %M Kbytes\t%E\" --  $WAF_DIR/waf \
 --run  \"$SIM_DIR/saf --run-time=50000 --seed=57140259 --total-nodes=40 \
 --run=$RUN_NUM \
 --wifi-radius=$RADIUS --relocation-period=$RELOCATION --replica-space=$SPACE \
 --request-timeout=50000 --data-size=256 --routing=AODV --start-delay=0	\
 --area-width=50 --area-length=50 --total-nodes=40 --data-items=40 \
 --access-frequency-type=$TYPE --standard-deviation=$S
 --min-speed=0 --max-speed=1 --min-pause=0 --max-pause=0\" " | bash

mv "$WAF_DIR/data-$RUN_NUM.sca" "$FOLDER_NAME/data-$(printf "%04i" $RUN_NUM).sca"
