#!/bin/bash

# Name: rssh.sh [Rapid SSH]
# Author:   Arthur "Damon" Mills
# Modified: 05.20.2018
# License:  GPLv3
#
# Usage: -c [count] -d [delay] SSH hostname [valid IP address]

# options

OPTION=$@

# variables

declare -i COUNT=5 # default value: 5 retries
declare -i DELAY=3 # default value: 3 second delay between retries
declare -i RETRY=1 # default value: incrimentor for SSH while..loop
declare -r USAGE="usage: $0 -c [count] -d [delay] hostname [IP address]"

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

if [[ "$HOST" =~ ^([0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.([0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.([0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\.([0-1]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])$ ]]; then
    # checks that valid hostname was entered
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