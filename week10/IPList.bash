#!/bin/bash

# Check if exactly one argument (the prefix) is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <Prefix>   # e.g., $0 192.168.1"
    exit 1
fi

prefix=$1

# List all IPs in the given /24 network 
for i in {1..254}
do
    echo "$prefix.$i"
done
