# Nginx docker container
[![Circle CI](https://circleci.com/gh/million12/docker-nginx.svg?style=svg)](https://circleci.com/gh/million12/docker-nginx)

[![CircleCI Build Status](https://img.shields.io/circleci/project/million12/docker-nginx/master.svg)](https://circleci.com/gh/million12/docker-nginx)
[![GitHub Open Issues](https://img.shields.io/github/issues/million12/docker-nginx.svg)](https://github.com/million12/docker-nginx/issues)
[![GitHub Stars](https://img.shields.io/github/stars/million12/docker-nginx.svg)](https://github.com/million12/docker-nginx)
[![GitHub Forks](https://img.shields.io/github/forks/million12/docker-nginx.svg)](https://github.com/million12/docker-nginx)
[![Stars on Docker Hub](https://img.shields.io/docker/stars/million12/nginx.svg)](https://hub.docker.com/r/million12/nginx)
[![Pulls on Docker Hub](https://img.shields.io/docker/pulls/million12/nginx.svg)](https://hub.docker.com/r/million12/nginx)
[![](https://images.microbadger.com/badges/image/million12/nginx.svg)](http://microbadger.com/images/million12/nginx)

This is a [million12/nginx](https://registry.hub.docker.com/u/million12/nginx/) docker container with Nginx web server, nicely tuned for a better performance.

# Features

##### - HTTP/2 support

##### - LDAP support

##### - directory structure
```
/data/www # meant to contain web content
/data/conf/nginx/ # extra Nginx configs to customise its settings (read more below)
```
The container will re-create the above structure in case it's missing (i.e. when using empty external /data volume container).

##### - default vhost

Default *catch-all* vhost is generated **IF** you set `NGINX_GENERATE_DEFAULT_VHOST=true`. It will serve the content from `/data/www/default` location.

##### - dummy SSL certificates

The default *catch-all* vhost is configured to work on HTTPS as well.

##### - internal HTTP/HTTPS proxy (if requested)

Set `SET_INTERNAL_PROXY_ON_PORT` and/or `SET_INTERNAL_HTTPS_PROXY_ON_PORT` to have internal transparent proxy on specified port. Useful when working with [BrowserSync](http://www.browsersync.io/) using `--proxy` option.

##### - error logging

Nginx `error_log` is set to `stderr` and therefore Nginx log is available only via `docker logs [contaienr]`, together with supervisor logs.

This is probably best approach if you'd like to source your logs from outside the container (e.g. via `docker logs` or CoreOS `journald') and you don't want to worry about logging and log management inside your container.

##### - graceful reload after config change

Folders `/etc/nginx/` and `/data/conf/nginx/` are monitored for any config changes and, when they happen, Nginx is gracefully reloaded.

##### - Nginx status page

Nginx status page is configured under `/nginx_status` URL on the default vhost. Also see `STATUS_PAGE_ALLOWED_IP` env variable described below.
Eample output:  

	Active connections: 1
	server accepts handled requests
	11475 11475 13566
	Reading: 0 Writing: 1 Waiting: 0


## Usage

```
docker run -d --name=web -p=80:80 -p=443:443 -e "NGINX_GENERATE_DEFAULT_VHOST=true" million12/nginx
```

With data container:  
```
docker run -d --name=web-data -v /data busybox
docker run -d --name=web --volumes-from=web-data -p=80:80 -e "NGINX_GENERATE_DEFAULT_VHOST=true" million12/nginx
```

After that you can see the default vhost content (something like: '*default vhost # created on [timestamp]*') when you open http://CONTAINER_IP:PORT/ in the browser.


## Customise

Modify Nginx global configuration (http {} context) by adding configs in the following locations:  
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

**NGINX_GENERATE_DEFAULT_VHOST**  
Default: `NGINX_GENERATE_DEFAULT_VHOST=false`  
Example: `NGINX_GENERATE_DEFAULT_VHOST=true`  
When set to `true`, dummy default (*catch-all*) Nginx vhost config file will be generated in `/etc/nginx/hosts.d/default.conf`.  
Use it if you need it, for example to test that your Nginx is working correctly AND/OR if you don't create default vhost config for your app but you still want some dummy catch-all vhost.

**SET_INTERNAL_PROXY_ON_PORT**  
Default: `SET_INTERNAL_PROXY_ON_PORT=null`  
Example: `SET_INTERNAL_PROXY_ON_PORT=3000`  
Configure additional proxy listening on `SET_INTERNAL_PROXY_ON_PORT` port.  
This might be useful during development, when container's ports are exposed outside under different ones. Because of different reasons you might want to access the project **inside** the container under the same port number as the one exposed outside. This is particularly handy for running inside the container e.g. integration tests or working with [BrowserSync](http://www.browsersync.io/) using `--proxy` option.

**SET_INTERNAL_HTTPS_PROXY_ON_PORT**  
Default: `SET_INTERNAL_HTTPS_PROXY_ON_PORT=null`  
Example: `SET_INTERNAL_HTTPS_PROXY_ON_PORT=3000`  
Similar to `SET_INTERNAL_PROXY_ON_PORT`, but the proxy then listens with SSL support and proxies the request to HTTPS as well. Note: if you use both, `SET_INTERNAL_PROXY_ON_PORT` and `SET_INTERNAL_HTTPS_PROXY_ON_PORT` options (to have HTTP and HTTPS support), you of course need to use two different port numbers.

**STATUS_PAGE_ALLOWED_IP**  
Default: `STATUS_PAGE_ALLOWED_IP=127.0.0.1`  
Example: `STATUS_PAGE_ALLOWED_IP=10.1.1.0/16`  
Configure ip address that would be allowed to see nginx status page on `/nginx_status` URL.  
**NOTE**: if `NGINX_GENERATE_DEFAULT_VHOST=false` (which is the default setting), you'll need to add:
```
include     /etc/nginx/conf.d/stub-status.conf;
```
to your own/custom vhost file (which you surely create for your application). Add it to the `server {}` context, this will define the `/nginx_status` location.


## Authors

Author: Marcin Ryzycki (<marcin@m12.io>)  
Author: Przemyslaw Ozgo (<linux@ozgo.info>)

---

**Sponsored by [Prototype Brewery](http://prototypebrewery.io/)** - the new prototyping tool for building highly-interactive prototypes of your website or web app. Built on top of [Neos CMS](https://www.neos.io/) and [Zurb Foundation](http://foundation.zurb.com/) framework.
