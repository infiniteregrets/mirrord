#!/usr/bin/env bash

set -ex

if [ $1 = "node" ]; then 
    MIRRORD_AGENT_TTL=100 $4/target/debug/mirrord exec --pod-name $5 -c $1 $4/$2 & 
else       
    MIRRORD_AGENT_TTL=100 $4/target/debug/mirrord exec --pod-name $5 -c $1 &    
fi 
pid=$!
sleep 15

curl -X POST --data @$4/e2e/data.txt $3
wait $pid
exit $?