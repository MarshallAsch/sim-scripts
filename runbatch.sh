#!/bin/bash

STARTNUM=$1
NUM_RUNS=$2
RADIUS=$3
RELOCATION=$4
SPACE=$5
SD=$6
if [ -z "$SD" ]; then SD=0 ; fi

TYPE=1
if [[ "$SD" != "0" ]]; then TYPE=3 ; fi


DATE=$(date +"%A %B %d, %Y")
FOLDER_NAME="BATCH-R${RADIUS}-T${RELOCATION}-C${SPACE}-SD${SD}"
NOTES="$FOLDER_NAME/NOTES.txt"
#TIME_FILE="$FOLDER_NAME/RUNTIME.txt"

SIM_DIR="../scratch/saf"
WAF_DIR=".."


SIM_COMMIT=$(git -C $SIM_DIR rev-parse --short HEAD)
SCRIPTS_COMMIT=$(git rev-parse --short HEAD)


mkdir -p "DATA/$FOLDER_NAME"

echo "RUNNING '$NUM_RUNS' sumulation runs of the configuration with: " >> "$NOTES"
echo "DATE: $DATE" >> "$NOTES"
echo "WIFI RADIUS: $RADIUS" >> "$NOTES"
echo "RELOCATION PERIOD: $RELOCATION" >> "$NOTES"
echo "REPLICA SPACE: $SPACE" >> "$NOTES"
echo "STANDARD DEVIATION: $SD" >> "$NOTES"
echo "SCRIPTS COMMIT: $SCRIPTS_COMMIT" >> "$NOTES"
echo "SIMULATION_COMMIT: $SIM_COMMIT" >> "$NOTES"
echo "" >> "$NOTES"
echo "===================================" >> "$NOTES"
echo "FULL command that was invoked:" >> "$NOTES"
echo "$WAF_DIR/waf --run  \"$SIM_DIR/saf --run-time=50000 --seed=57140259 --total-nodes=40 \
 --run=$RUN_NUM \
 --wifi-radius=$RADIUS --relocation-period=$RELOCATION --replica-space=$SPACE \
 --request-timeout=50000 --data-size=256 --routing=AODV --start-delay=0	\
 --area-width=50 --area-length=50 --total-nodes=40 --data-items=40 \
 --access-frequency-type=$TYPE --standard-deviation=$S
 --min-speed=0 --max-speed=1 --min-pause=0 --max-pause=0\" "  >> "$NOTES"

for (( i = STARTNUM; i < STARTNUM+NUM_RUNS; i++ )); do
    echo "$i $RADIUS $RELOCATION  $SPACE $TYPE $SD $SIM_DIR $WAF_DIR $FOLDER_NAME" >> argfile.txt
	#./runOne.sh $i $RADIUS $RELOCATION  $SPACE $TYPE $SD $SIM_DIR $WAF_DIR $FOLDER_NAME $TIME_FILE
	#mv "$WAF_DIR/data-$i.sca" "$FOLDER_NAME/data-$i.sca"
done
