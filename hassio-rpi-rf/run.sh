#!/bin/bash
set -e

code=$(cat /data/options.json | jq -r '.code')

python3 ${code} 
