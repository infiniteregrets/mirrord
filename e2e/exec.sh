#!/usr/env bash

assert() {
    if [ $1 -ne $2 ]; then
        echo "Assertion failed: expected $2, got $1"
        exit 1
    fi
}

set -ex

echo "Non-existent binary"
$1/target/debug/mirrord exec --pod-name $2 -c random-binary
assert $? 0

echo "Non-existent pod"
$1/target/debug/mirrord exec --pod-name random-pod -c /bin/ls
assert $? 0

echo "Non-existent namespace"
$1/target/debug/mirrord exec --pod-name $2 -c /bin/ls -a random-namespace
assert $? 0

echo "Non-existent agent image"
echo "TODO"

echo "Non-existent agent pod namespace"
$1/target/debug/mirrord exec --pod-name $2 -c /bin/ls -n random-namespace
assert $? 0





