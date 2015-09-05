#!/bin/sh

#
# This script will be placed in /config/init/ and run when container starts.
# It creates (if they're not exist yet) necessary directories
# from where custom Nginx configs can be loaded (from mounted /data volumes).
#

set -e

mkdir -p /data/conf/nginx/addon.d
mkdir -p /data/conf/nginx/conf.d
mkdir -p /data/conf/nginx/hosts.d
mkdir -p /data/conf/nginx/nginx.d
chmod 711 /data/conf/nginx

mkdir -p /data/tmp/nginx/client_temp
mkdir -p /data/tmp/nginx/proxy_temp
chmod 711 /data/tmp/nginx

mkdir -p /data/www
chown -R www:www /data/www
