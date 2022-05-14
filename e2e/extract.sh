#!/usr/env bash

set -ex

echo "creating a new directory"
mkdir extract-dir

$1/target/debug/mirrord extract extract-dir

if [ $? -ne 0 ]; then
    echo "extract failed"
    exit 1
fi

echo "verifying extracted file exists"
if [ ! -f extract-dir/libmirrord_layer.so ]; then
    echo "extracted file does not exist"
    exit 1
fi

echo "extract in a non existent directory"
$1/target/debug/mirrord extract does-not-exist

if [ $? -eq 0 ]; then
    echo "extract should have failed"
    exit 1
fi
