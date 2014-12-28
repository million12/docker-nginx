#!/bin/sh

#
# Configure internal transparent proxy on specified port (SET_INTERNAL_PROXY_ON_PORT)
# which redirect all traffic to localhost:80. See README for more info.
#

PROXY_SOURCE_CONF="/config/init/vhost-proxy.conf"
PROXY_TARGET_CONF="/etc/nginx/hosts.d/internal-proxy.conf"

if [ ! -z "${SET_INTERNAL_PROXY_ON_PORT+xxx}" ] && [ ! -z "${SET_INTERNAL_PROXY_ON_PORT}" ]; then
  cat $PROXY_SOURCE_CONF | sed "s/%proxy_port%/$SET_INTERNAL_PROXY_ON_PORT/g" > $PROXY_TARGET_CONF
  echo "Nginx: internal proxy set on port :$SET_INTERNAL_PROXY_ON_PORT."; echo
fi
