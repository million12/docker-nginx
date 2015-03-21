# Nginx docker container
[![Circle CI](https://circleci.com/gh/million12/docker-nginx.svg?style=svg)](https://circleci.com/gh/million12/docker-nginx)

This is a [million12/nginx](https://registry.hub.docker.com/u/million12/nginx/) docker container with Nginx web server, nicely tuned for a better performance.

Things included:

##### - directory structure
```
/data/www # meant to contain web content
/data/www/default # default vhost directory
/data/conf/nginx/ # extra configs to customise Nginx (see below)
```
The container will re-create above structure if it's missing - in case you'd use external /data volume.

##### - default vhost

Default vhost is configured and served from `/data/www/default`.

##### - error logging

Nginx `error_log` is set to `stderr` and therefore Nginx log is available only via `docker logs [contaienr]`, together with supervisor logs.

This is probably best approach if you'd like to source your logs from outside the container (e.g. via `docker logs` or CoreOS `journald') and you don't want to worry about logging and log management inside your container.

#### - graceful reload after config change

Folders `/etc/nginx/` and `/data/conf/nginx/` are monitored for any config changes and, when they happen, Nginx is gracefully reloaded.


## Usage

`docker run -d -p=80:80 -p=443:443 million12/nginx`

With data container:  
```
docker run -d -v /data --name=web-data busybox
docker run -d --volumes-from=web-data -p=80:80 --name=web million12/nginx
```

After that you can see the default vhost content (something like: '*default vhost created on [timestamp]*') when you open http://CONTAINER_IP:PORT/ in the browser.

## Customise

Modify Nginx global configuration (http {} context) by adding configs in following locations:  
```
/etc/nginx/nginx.d/*.conf
/data/conf/nginx/nginx.d/*.conf

/etc/nginx/addon.d/*.conf
/data/conf/nginx/addon.d/*.conf
```

Add vhosts by placing their configs in following locations:  
```
/etc/nginx/hosts.d/*.conf
/data/conf/nginx/hosts.d/*.conf
```

Extra configs to include inside vhost.conf, in *server {}* context (already included in the default vhost):  
```
include     /etc/nginx/conf.d/default-*.conf;
include     /data/conf/nginx/conf.d/default-*.conf;
```

## ENV variables

**SET_INTERNAL_PROXY_ON_PORT**  
Default: `SET_INTERNAL_PROXY_ON_PORT=null`  
Example: `SET_INTERNAL_PROXY_ON_PORT=3000`  
Configure additional proxy listening on `SET_INTERNAL_PROXY_ON_PORT` port.  
This might be useful during development, when container's ports are exposed outside under different ones. Because of different reasons you might want to access the project **inside** the container under the same port number as the one exposed outside. This is particularly handy for running inside the container e.g. integration tests or working with [BrowserSync](http://www.browsersync.io/) using `--proxy` option.

**SET_INTERNAL_HTTPS_PROXY_ON_PORT**  
Default: `SET_INTERNAL_HTTPS_PROXY_ON_PORT=null`  
Example: `SET_INTERNAL_HTTPS_PROXY_ON_PORT=3000`  
Similar to `SET_INTERNAL_PROXY_ON_PORT`, but the proxy then listens with SSL support and proxies the request to HTTPS as well. Note: if you use both, `SET_INTERNAL_PROXY_ON_PORT` and `SET_INTERNAL_HTTPS_PROXY_ON_PORT` options (to have HTTP and HTTPS support), you of course need to use two different port numbers.

## Authors

Author: ryzy (<marcin@m12.io>)  
Author: pozgo (<linux@ozgo.info>)

---

**Sponsored by** [Typostrap.io - the new prototyping tool](http://typostrap.io/) for building highly-interactive prototypes of your website or web app. Built on top of TYPO3 Neos CMS and Zurb Foundation framework.
