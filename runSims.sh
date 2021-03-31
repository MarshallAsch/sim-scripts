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



STARTNUM=1
NUM_RUNS=10

# default values if none is specified
RADIUS=7
RELOCATION=256
SPACE=10


### RADUS RANGE
STARTNUM=1
for (( i = 1; i < 20; i++ )); do
	#statements
	start=$((STARTNUM + (i-1) * NUM_RUNS))
	./runbatch.sh $start $NUM_RUNS $i $RELOCATION $SPACE
done

### CAPACITY RANGE
STARTNUM=191
for (( i = 1; i < 40; i++ )); do
	#statements
	start=$((STARTNUM + (i-1) * NUM_RUNS))
	./runbatch.sh $start $NUM_RUNS $RADIUS $RELOCATION $i
done

#for (( i = 20; i < 40; i++ )); do
#	#statements
#	start=$((STARTNUM + (i-1) * NUM_RUNS))
#	./runbatch.sh $start $NUM_RUNS $RADIUS $RELOCATION $i
#done


### RELOCATION RANGE
STARTNUM=581
for (( i = 1, j = 1; i <= 8192; i+=200, j++ )); do
	#statements
	start=$((STARTNUM + (j-1) * NUM_RUNS))
	./runbatch.sh $start $NUM_RUNS $RADIUS $i $SPACE
done


### STANDARD DEVIATION RANGE
STARTNUM=981
for (( i = 0; i <= 10; i++ )); do
    #statements
    sd=$(echo "scale=2; $i/10" | bc | awk '{printf "%.2f", $0}')
    start=$((STARTNUM + (i) * NUM_RUNS))
   ./runbatch.sh $start $NUM_RUNS $RADIUS $RELOCATION $SPACE $sd
done
