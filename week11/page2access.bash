#!/bin/bash

grep "page2.html" /var/log/apache2/access.log | cut -d ' ' -f1,7 | tr '/' ' ' | tr -s ' '
