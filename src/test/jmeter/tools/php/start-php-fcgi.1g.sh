#!/bin/bash

cd "$(dirname "$0")"


phpPID=`pgrep -f "php-cgi"`
echo kill "$phpPID"
kill "$phpPID"


php-cgi -b 127.0.0.1:9123 -c php.1g.ini