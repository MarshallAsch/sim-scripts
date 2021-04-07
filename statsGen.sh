#!/bin/bash

SEPERATOR="\t"
DATA_DIR=$1

if [ -z "$DATA_DIR" ]
then
    echo "You must specify a data directory for where the files are"
    exit 1
fi

export STATS_FILE="$DATA_DIR/stats.txt"

f=$(find $DATA_DIR -type f -name "*.sca" | tail -n 1)


# This script will tansose the rows of the output into columns
# usefull for converting the rows of the data files into columns in a TSV or CSV
# credit for this goes to https://stackoverflow.com/a/1729980/4816497
export AWK_SCRIPT='
{
    for (i=1; i<=NF; i++)  {
        a[NR,i] = $i
    }
}
NF>p { p = NF }
END {
    for(j=1; j<=p; j++) {
        str=a[1,j]
        for(i=2; i<=NR; i++){
            str=str" "a[i,j];
        }
        print str
    }
}'

FIELD_HEADERS=$(cat $f | grep "scalar" | grep -v "Author" | cut -d ' ' -f 3 | awk "$AWK_SCRIPT")

echo "radius relocation-period capacity standard-deviation $FIELD_HEADERS total-traffic accessability" > $STATS_FILE

# collect the stats for
handle() {
    SET_DIR=$1
    DIR=$(basename $SET_DIR | sed -E 's/[A-Z]+//g')
    R=$(echo $DIR | cut -d '-' -f 2)
    T=$(echo $DIR | cut -d '-' -f 3)
    C=$(echo $DIR | cut -d '-' -f 4)
    SD=$(echo $DIR | cut -d '-' -f 5)

    files=$(find $SET_DIR  -type f -name "*.sca")

    # collect the values for each individual run of the batch
    VALS="$R $T $C $SD"
    for f in ${files}; do
        values=$(cat $f | grep "scalar" | grep -v "Author" | cut -d ' ' -f 4 | awk "$AWK_SCRIPT")

        cache=$(cat $f | grep 'cache-hits' | cut -d ' ' -f 4)
        requests=$(cat $f | grep 'requests-sent' | cut -d ' ' -f 4)
        responces=$(cat $f | grep 'responses-sent' | cut -d ' ' -f 4)
        req_success=$(cat $f | grep 'time-for-success-count' | cut -d ' ' -f 4)

        total_lookup=$(($cache + $requests))
        found=$(($cache + $req_success))
        traffic=$(($requests + $responces))
        accessability=$(echo "scale=6; $found / $total_lookup" | bc | awk '{printf "%.6f", $0}')

        echo "$VALS $values $traffic $accessability" >> $STATS_FILE

    done;
}

export -f handle
find $DATA_DIR -mindepth 1 -maxdepth 1 -type d -exec bash -c 'handle "$@"' bash  {} \;

# convert to a TSV or CSV file
sed -i "s/ /$SEPERATOR/g" $STATS_FILE
