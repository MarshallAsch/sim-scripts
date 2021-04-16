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

echo "radius relocation-period capacity standard-deviation $FIELD_HEADERS app-traffic reallocation-traffic total-traffic app-lost reallocation-lost accessability" > $STATS_FILE

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
        cache=$(cat $f | grep 'cache-hit' | cut -d ' ' -f 4)

        look_sent=$(cat $f | grep 'lookup-sent' | cut -d ' ' -f 4)
        look_rcv=$(cat $f | grep 'lookup-rcv' | cut -d ' ' -f 4)
        look_rsp_sent=$(cat $f | grep 'lookup-rsp-sent' | cut -d ' ' -f 4)
        look_timeout=$(cat $f | grep 'lookup-timeout' | cut -d ' ' -f 4)
        look_ontime=$(cat $f | grep 'lookup-ontime-delay-count' | cut -d ' ' -f 4)
        look_late=$(cat $f | grep 'lookup-late-delay-count' | cut -d ' ' -f 4)


        # timing values to be used later, not in these inital sims
        #=$(cat $f | grep 'lookup-ontime-delay-total' | cut -d ' ' -f 4)
        #=$(cat $f | grep 'lookup-ontime-delay-average' | cut -d ' ' -f 4)
        #=$(cat $f | grep 'lookup-ontime-delay-max' | cut -d ' ' -f 4)
        #=$(cat $f | grep 'lookup-ontime-delay-min' | cut -d ' ' -f 4)
        #=$(cat $f | grep 'lookup-late-delay-total' | cut -d ' ' -f 4)
        #=$(cat $f | grep 'lookup-late-delay-average' | cut -d ' ' -f 4)
        #=$(cat $f | grep 'lookup-late-delay-max' | cut -d ' ' -f 4)
        #=$(cat $f | grep 'lookup-late-delay-min' | cut -d ' ' -f 4)


        realoc_sent=$(cat $f | grep 'realloc-sent' | cut -d ' ' -f 4)
        realloc_rcv=$(cat $f | grep 'realloc-rcv' | cut -d ' ' -f 4)
        realloc_rsp_sent=$(cat $f | grep 'realloc-rsp-sent' | cut -d ' ' -f 4)
        realloc_timeout=$(cat $f | grep 'realloc-timeout' | cut -d ' ' -f 4)
        realloc_ontime=$(cat $f | grep 'realloc-ontime-delay-count' | cut -d ' ' -f 4)
        realloc_late=$(cat $f | grep 'realloc-late-delay-count' | cut -d ' ' -f 4)

        # timing values to be used later, not in these inital sims
        #=$(cat $f | grep 'realloc-ontime-delay-total' | cut -d ' ' -f 4)
        #=$(cat $f | grep 'realloc-ontime-delay-average' | cut -d ' ' -f 4)
        #=$(cat $f | grep 'realloc-ontime-delay-max' | cut -d ' ' -f 4)
        #=$(cat $f | grep 'realloc-ontime-delay-min' | cut -d ' ' -f 4)
        #=$(cat $f | grep 'realloc-late-delay-total' | cut -d ' ' -f 4)
        #=$(cat $f | grep 'realloc-late-delay-average' | cut -d ' ' -f 4)
        #=$(cat $f | grep 'realloc-late-delay-max' | cut -d ' ' -f 4)
        #=$(cat $f | grep 'realloc-late-delay-min' | cut -d ' ' -f 4)

        application_lookups=$(($cache + $look_sent))
        realloc_traffic=$(($realloc_sent + $realloc_rsp_sent))
        application_traffic=$(($look_sent + $look_rsp_sent))
        application_success=$(($cache + $look_ontime))

        application_lost=$(($look_sent - $look_rcv + $look_rsp_sent - $look_ontime - $look_late))
        realloc_lost=$(($realloc_sent - $realloc_rcv + $realloc_rsp_sent - $realloc_ontime - $realloc_late))

        total_traffic=$(($look_sent + $look_rsp_sent + $realloc_sent + $realloc_rsp_sent))
        accessability=$(echo "scale=6; $application_success / $application_lookups" | bc | awk '{printf "%.6f", $0}')

        echo "$VALS $values $application_traffic $realloc_traffic $total_traffic $application_lost $realloc_lost $accessability" >> $STATS_FILE

    done;
}

export -f handle
find $DATA_DIR -mindepth 1 -maxdepth 1 -type d -exec bash -c 'handle "$@"' bash  {} \;

# convert to a TSV or CSV file
sed -i "s/ /$SEPERATOR/g" $STATS_FILE
