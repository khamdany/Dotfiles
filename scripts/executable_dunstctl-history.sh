#!/bin/bash
#if [ $# -lt 1 ]; then
#    echo "Usage: $0 arg1"
#    exit 1
#fi

v1=$1


dunstctl history | rg -Ui '"message" : \{[^{}]*"data" : ".*'"$v1"'.*"[^{}]*\}'
