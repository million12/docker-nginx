# Docker container with plain Nginx

This is [million12/nginx](https://registry.hub.docker.com/u/million12/nginx/) docker container with pure Nginx, but configured and tuned for better performance.

##### - directory structure

```
/data/www # meant to contain web content
/data/www/default # default vhost directory
/data/conf/nginx/ # extra configs to customise Nginx (see below)
/data/logs/nginx-error.log # Nginx error log
```
If you run this container with `/data` mounted from e.g. data-only container, to avoid errors and warnings, expected directory structure inside `/data` will be (re)created. 

##### - default vhost

Default vhost is configured and served from `/data/www/default`.


## Usage

`docker run -d -p=80:80 -p=443:443 million12/nginx`

With data container:  
```
docker run -d -v /data --name=web-data busybox
docker run -d --volumes-from=web-data -p=80:80 -p=443:443 million12/nginx
```


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
