FROM million12/centos-supervisor:latest
MAINTAINER Marcin Ryzycki marcin@m12.io, Przemyslaw Ozgo linux@ozgo.info

ADD nginx.repo /etc/yum.repos.d/nginx.repo

# - Install Nginx
# - Rename nginx:nginx user/group to www:www
RUN \
  yum install -y nginx && \
  yum clean all && \

  groupmod --gid 80 --new-name www nginx && \
  usermod --uid 80 --home /data/www --gid 80 --login www --shell /bin/bash --comment www nginx && \

  rm -rf /etc/nginx/*.d /etc/nginx/*_params

# Add whole /etc/nginx/ configuration
ADD nginx/ /etc/nginx/

# Add config/init scripts to run after container has been started
ADD config/ /config/

ADD supervisord.conf /etc/supervisord.d/nginx.conf

EXPOSE 80
EXPOSE 443
