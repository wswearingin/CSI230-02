#!/bin/bash

grep -f "$1" "$2" | awk '{
    ip = $1
    # Extract date/time from $4 and remove the leading "["
    dt = substr($4, 2)
    page = $7
    print ip, dt, page
}' > report.txt
