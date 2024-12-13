#!/bin/bash

# Fetch the HTML from the local server
curl -s http://127.0.0.1/IOC-1.html \
| grep "<td>" \
| sed 's/.*<td>//; s/<\/td>.*//' \
| awk 'NR % 2 == 1' \
> ioc.txt
