#!/usr/bin/env bash

set -x

job=$(kubectl get jobs -o custom-columns=:metadata.name | tr -d '\n')
pod=$(kubectl get pods -o custom-columns=:metadata.name | grep $job)

sleep 150

kubectl get jobs | grep $job

if [ $? -ne 1]; 
then
    echo "Job still exists!"
    exit 1
fi

kubectl get pods | grep $pod

if [ $? -ne 1]; 
then
    echo "Pod still exists!"
    exit 1
fi