#!/bin/bash
set -e

code=$(cat /data/options.json | jq -r '.code')

#requirements=$(cat /data/options.json | jq -r 'if .requirements then .requirements | join(" ") else "" end')
#clean=$(cat /data/options.json | jq -r '.clean //empty')
#py3=$(cat /data/options.json | jq -r '.python3 // empty')

#PYTHON=$(which python3)

#if [ "${py3}" == "true" ];
#then
#    PYTHON=$(which python3)
#fi

python3 ${code} 
