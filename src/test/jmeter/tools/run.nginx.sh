#!/bin/bash


NGINX_CONF=$1
NGINX_LOG_DIR=$2

echo cd "$(dirname "$0")"/nginx
cd "$(dirname "$0")"/nginx

nginxPID=`pgrep -f "nginx -c "`
echo kill "$nginxPID"
kill "$nginxPID"

echo mkdir -p "$NGINX_LOG_DIR"
mkdir -p "$NGINX_LOG_DIR"


echo nginx -c "$NGINX_CONF"
nginx -c "$NGINX_CONF"