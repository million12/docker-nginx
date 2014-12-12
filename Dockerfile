FROM million12/centos-supervisor:latest
MAINTAINER Marcin Ryzycki marcin@m12.io, Przemyslaw Ozgo linux@ozgo.info

# - Install Nginx
# - Rename nginx:nginx user/group to www:www
# - Fix permission for /var/lib/nginx which contains Nginx tmp directories (used e.g. during uploading files from upstream servers)
RUN \
  rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm && \
  yum install -y nginx && \
  yum clean all && \

  groupmod --gid 80 --new-name www nginx && \
  usermod --uid 80 --home /data/www --gid 80 --login www --shell /bin/bash --comment www nginx && \

  rm -rf /etc/nginx/*.d /etc/nginx/*_params && \
  chown -R www:www /var/lib/nginx

ADD container-files /

EXPOSE 80 443
