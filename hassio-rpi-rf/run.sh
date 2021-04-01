#!/bin/bash
set -e

requirements=$(cat /data/options.json | jq -r 'if .requirements then .requirements | join(" ") else "" end')
code=$(cat /data/options.json | jq -r '.code')
clean=$(cat /data/options.json | jq -r '.clean //empty')
py3=$(cat /data/options.json | jq -r '.python3 // empty')

PYTHON=$(which python3)

if [ "${py3}" == "true" ];
then
    PYTHON=$(which python3)
fi

if [ -n "$requirements" ];
then
    if [ "$clean" == "true" ];
    then
	rm -rf /data/venv/
    fi
    if [ ! -f "/data/venv/bin/activate" ];
    then
       mkdir -p /data/venv/
       cd /data/venv
       virtualenv -p ${PYTHON} .
       . bin/activate
    fi
    pip3 install -U ${requirements}
fi
python3 ${code} 

sleep 120
