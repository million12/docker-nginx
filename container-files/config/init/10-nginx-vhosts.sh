#!/bin/sh

#
# Configure internal transparent proxy on specified port (SET_INTERNAL_PROXY_ON_PORT)
# which redirect all traffic to localhost:80. See README for more info.
#

VHOSTS_DEFAULT_SOURCE_CONF="/config/init/vhost-default.conf"
VHOSTS_DEFAULT_TARGET_CONF="/etc/nginx/hosts.d/default.conf"

PROXY_SOURCE_CONF="/config/init/vhost-proxy.conf"
PROXY_TARGET_CONF="/etc/nginx/hosts.d/internal-proxy.conf"

PROXY_SOURCE_CONF_HTTPS="/config/init/vhost-proxy-https.conf"
PROXY_TARGET_CONF_HTTPS="/etc/nginx/hosts.d/internal-proxy-https.conf"

if [ "${NGINX_GENERATE_DEFAULT_VHOST^^}" = TRUE ]; then
  cat $VHOSTS_DEFAULT_SOURCE_CONF > $VHOSTS_DEFAULT_TARGET_CONF
  mkdir -p /data/www/default && echo "default vhost # created on $(date)" > /data/www/default/index.html
  echo "Nginx: default *catch-all* vhost generated."; echo
fi

if [ ! -z "${SET_INTERNAL_PROXY_ON_PORT+xxx}" ] && [ ! -z "${SET_INTERNAL_PROXY_ON_PORT}" ]; then
  cat $PROXY_SOURCE_CONF | sed "s/%proxy_port%/$SET_INTERNAL_PROXY_ON_PORT/g" > $PROXY_TARGET_CONF
  echo "Nginx: internal proxy set on port :$SET_INTERNAL_PROXY_ON_PORT."; echo
fi

if [ ! -z "${SET_INTERNAL_HTTPS_PROXY_ON_PORT+xxx}" ] && [ ! -z "${SET_INTERNAL_HTTPS_PROXY_ON_PORT}" ]; then
  cat $PROXY_SOURCE_CONF_HTTPS | sed "s/%proxy_port%/$SET_INTERNAL_HTTPS_PROXY_ON_PORT/g" > $PROXY_TARGET_CONF_HTTPS
  echo "Nginx: internal HTTPS proxy set on port :$SET_INTERNAL_HTTPS_PROXY_ON_PORT."; echo
fi
