#!/bin/bash
#
#simulation plan:
#
# range 1-19
# capacity 1-39
# relaocation period 1-8192, every 200
#
# 10 runs per value
#
# Total 991 simulation runss
#
#


DATA_DIR=$1

if [ -z "$DATA_DIR" ]
then
    echo "You must specify a data directory for where the files are"
    exit 1
fi

if [ -d "$DATA_DIR" ]
then
    echo "Can not use the same data directory that was used previously, please pick another one"
    exit 1
fi

mkdir -p $DATA_DIR
ARG_FILE=$(mktemp -p $DATA_DIR)


STARTNUM=1
NUM_RUNS=1

# default values if none is specified
RADIUS=7
RELOCATION=256
SPACE=10
SD="0.00"

DATE=$(date +"%A-%B-%d-%Y")
SIM_DIR="scratch/saf"
WAF_DIR=".."
SIM_COMMIT=$(git -C ../$SIM_DIR rev-parse --short HEAD)
SCRIPT_COMMIT=$(git rev-parse --short HEAD)



### RADUS RANGE
STARTNUM=1
for (( i = 1; i < 2; i++ )); do
	#statements
	start=$((STARTNUM + (i-1) * NUM_RUNS))
	./runBatch.sh $start $NUM_RUNS $i $RELOCATION $SPACE $SD $DATE $SIM_DIR $WAF_DIR $SIM_COMMIT $SCRIPT_COMMIT $ARG_FILE $DATA_DIR
done

### CAPACITY RANGE
STARTNUM=191
for (( i = 1; i < 40; i++ )); do
	#statements
	start=$((STARTNUM + (i-1) * NUM_RUNS))
	./runBatch.sh $start $NUM_RUNS $RADIUS $RELOCATION $i $SD $DATE $SIM_DIR $WAF_DIR $SIM_COMMIT $SCRIPT_COMMIT $ARG_FILE $DATA_DIR
done

### RELOCATION RANGE
STARTNUM=581
for (( i = 1, j = 1; i <= 8192; i+=200, j++ )); do
	#statements
	start=$((STARTNUM + (j-1) * NUM_RUNS))
	./runBatch.sh $start $NUM_RUNS $RADIUS $i $SPACE $SD $DATE $SIM_DIR $WAF_DIR $SIM_COMMIT $SCRIPT_COMMIT $ARG_FILE $DATA_DIR
done

### STANDARD DEVIATION RANGE
STARTNUM=991
for (( i = 0; i <= 10; i++ )); do
    #statements
    sd=$(echo "scale=2; $i/10" | bc | awk '{printf "%.2f", $0}')
    start=$((STARTNUM + (i) * NUM_RUNS))
   ./runBatch.sh $start $NUM_RUNS $RADIUS $RELOCATION $SPACE $sd $DATE $SIM_DIR $WAF_DIR $SIM_COMMIT $SCRIPT_COMMIT $ARG_FILE $DATA_DIR
done


## Run parallel
parallel -a $ARG_FILE --colsep ' ' -j+0 --eta ./runOne.sh
