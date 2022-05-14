#!/usr/bin/env bash

set -ex

sudo apt-get update -y
sudo apt-get install -y nodejs npm \
    libpcap-dev cmake curl 

npm install express

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y