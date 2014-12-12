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


## Authors

Author: ryzy (<marcin@m12.io>)  
Author: pozgo (<linux@ozgo.info>)

---

**Sponsored by** [Typostrap.io - the new prototyping tool](http://typostrap.io/) for building highly-interactive prototypes of your website or web app. Built on top of TYPO3 Neos CMS and Zurb Foundation framework.
