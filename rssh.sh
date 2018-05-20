#!/bin/bash

# Name: rssh.sh [Rapid SSH]
# Author:   Arthur "Damon" Mills
# Modified: 05.20.2018
# License:  GPLv3
#
# Usage: -c [count] -d [delay] SSH hostname

# options

OPTION=$@

# variables

COUNT=5     # default value: 5 retries
DELAY=3     # default value: 3 second delay between retries
RETRY=1     # default value: incrimentor for SSH while..loop
USAGE="usage: $0 -c [count] -d [delay] hostname"

# main rssh.sh

while getopts ":hc::d:" OPTION; do   
# checks that all options passed are valid
    case ${OPTION} in
        h )
            echo $USAGE
            exit 1
        ;;
        c ) 
        if ! [[ "$OPTARG" =~ ^[0-9]+$ ]]; then
            # checks for numeric value
            echo "error: -c [count] must be a numeric value"
            echo $USAGE
            exit 1
        else
            COUNT=$OPTARG
        fi
        ;;
        d ) 
        if ! [[ "$OPTARG" =~ ^[0-9]+$ ]]; then
            # checks for numeric value
            echo "error: -d [delay] must be a numeric value"
            echo $USAGE
            exit 1
        else
            DELAY=$OPTARG
        fi
        ;;
        * ) 
        echo "error: invalid option"
        echo $USAGE
        exit 1
        ;;
    esac
done
shift $((OPTIND -1))

HOST=$1     # assigns hostname for SSH command

if [ ! -z "$HOST" ]; then
    # checks that hostname was entered
    while [ $RETRY -le $((COUNT)) ]; do
        echo "ssh: connection attempt ${RETRY}..."
        ssh $HOST
        sleep $DELAY
        (( RETRY++ ))
    done    
else
    echo "error: invalid ip address"
    echo $USAGE
    exit 1
fi

exit 0 # end rssh.sh