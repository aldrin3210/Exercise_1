#!/bin/bash

free
TOTAL_MEMORY = $(free | grep Mem: | awk '{print $3/$2 *100 }')

MEMORY_USAGE=$(printf "%1.f" $TOTAL_MEMORY)

echo "Memory usage ${MEMORY_USAGE}%"

    while getops "c:w:e:" opt; do

    case $opt in 
    c)
    CT=${OPTARG} >&2
    ;;
    w)
    WT=${OPTARG} >&2
    ;;
    e)
    EA=${OPTARG} >&2
    ;;
    esac

    done

    if [ $WT -gt $CT ]
    then
    echo "Invalid parameter(s). Critical (-c), Warning (-w), Email(-e)"
    exit 1
    fi

    if [ $MEMORY_USAGE -lt ${WT} ]
    then
    echo 0
    exit 1
    fi
    
    if [ $MEMORY_USAGE -ge $WT ]
    then
        if [ $MEMORY_USAGE -lt $CT ];
        then
            echo 1
            exit 1
        fi
    fi

    if [ $MEMORY_USAGE -ge $CT ]
    then 
    echo 2
    exit 1
    fi
    