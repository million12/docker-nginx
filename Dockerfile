FROM million12/centos-supervisor:latest

ENV \
  NGINX_VERSION=1.9.9 \
  NGINX_GENERATE_DEFAULT_VHOST=false \
  STATUS_PAGE_ALLOWED_IP=127.0.0.1

RUN \
  rpm --rebuilddb && yum clean all && \
  yum install -y wget unzip openssl openssl-devel pcre-devel openldap-devel && \
  yum groupinstall -y "Development Tools" && \
  mkdir -p /tmp/nginx && \
  cd /tmp/ && wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
  tar zxf nginx-${NGINX_VERSION}.tar.gz -C /tmp/nginx --strip-components=1 && \
  wget https://github.com/kvspb/nginx-auth-ldap/archive/master.zip && \
  unzip master.zip && rm -f /tmp/nginx-${NGINX_VERSION}.tar.gz /tmp/master.zip && \
  cd /tmp/nginx && \
  ./configure \
  --user=www \
  --group=www \
  --prefix=/etc/nginx \
  --sbin-path=/usr/sbin/nginx \
  --conf-path=/etc/nginx/nginx.conf \
  --pid-path=/var/run/nginx.pid \
  --lock-path=/var/run/nginx.lock \
  --error-log-path=/var/log/nginx/error.log \
  --http-log-path=/var/log/nginx/access.log \
  --with-http_gzip_static_module \
  --with-http_stub_status_module \
  --with-http_ssl_module \
  --with-pcre \
  --with-file-aio \
  --with-http_realip_module \
  --with-http_v2_module \
  --add-module=/tmp/nginx-auth-ldap-master/ \
  --with-ipv6 \
  --with-debug && \
  make && make install && \
  rm -rf /tmp/nginx-${NGINX_VERSION} && rm -rf /tmp/nginx-auth-ldap-master/ && \
  yum groupremove -y "Development Tools" && \
  yum clean all && \

  `# Adding user/group www:www, also set uid:gid to 80:80 (just to make it nice)` \
  groupadd -g 80 www && \
  useradd -g 80 -d /data/www -u 80 -s /bin/bash -c www www && \

  `# Clean-up /etc/nginx/ directory from all not needed stuff...` \
  rm -rf /etc/nginx/*.d /etc/nginx/*_params && \

  `# Prepare dummy SSL certificates` \
  mkdir -p /etc/nginx/ssl && \
  openssl genrsa -out /etc/nginx/ssl/dummy.key 2048 && \
  openssl req -new -key /etc/nginx/ssl/dummy.key -out /etc/nginx/ssl/dummy.csr -subj "/C=GB/L=London/O=Company Ltd/CN=docker" && \
  openssl x509 -req -days 3650 -in /etc/nginx/ssl/dummy.csr -signkey /etc/nginx/ssl/dummy.key -out /etc/nginx/ssl/dummy.crt

ADD container-files /

EXPOSE 80 443
