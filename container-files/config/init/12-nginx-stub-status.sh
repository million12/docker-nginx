#!/bin/sh
#
# Configure access IP address for nginx status page under /nginx_status
#
sed -i "s|allow 127.0.0.1|allow ${STATUS_PAGE_ALLOWED_IP}|g" /etc/nginx/conf.d/stub-status.conf
# Only echo this message to log console, not when in TTY mode.
[ -t 0 ] || echo "Nginx status page: allowed address set to $STATUS_PAGE_ALLOWED_IP."
