FROM million12/centos-supervisor:4.0.2

ENV \
  NGINX_GENERATE_DEFAULT_VHOST=false \
  STATUS_PAGE_ALLOWED_IP=127.0.0.1 \
  NGINX_VERSION=1.15.12-1

ADD container-files/etc/yum.repos.d/nginx.repo /etc/yum.repos.d/

RUN \
  yum install -y nginx-${NGINX_VERSION}.el7.ngx && \
  yum clean all && \

  `# Rename nginx:nginx user/group to www:www, also set uid:gid to 80:80 (just to make it nice)` \
  groupmod --gid 80 --new-name www nginx && \
  usermod --uid 80 --home /data/www --gid 80 --login www --shell /bin/bash --comment www nginx && \

  `# Clean-up /etc/nginx/ directory from all not needed stuff...` \
  rm -rf /etc/nginx/*.d /etc/nginx/*_params && \

  `# Prepare dummy SSL certificates` \
  mkdir -p /etc/nginx/ssl && \
  openssl genrsa -out /etc/nginx/ssl/dummy.key 2048 && \
  openssl req -new -key /etc/nginx/ssl/dummy.key -out /etc/nginx/ssl/dummy.csr -subj "/C=GB/L=London/O=Company Ltd/CN=docker" && \
  openssl x509 -req -days 3650 -in /etc/nginx/ssl/dummy.csr -signkey /etc/nginx/ssl/dummy.key -out /etc/nginx/ssl/dummy.crt

ADD container-files /

EXPOSE 80 443
