#
# Nginx Dockerfile
#
# https://github.com/dockerfile/nginx
#

# Pull base image.
# FROM dockerfile/ubuntu
FROM raw34/ubuntu

# Install Nginx.
RUN \
  add-apt-repository -y ppa:nginx/stable && \
  apt-get update && \
  apt-get install -y nginx && \
  rm -rf /var/lib/apt/lists/* && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx

# Define mountable directories.
# VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]
VOLUME ["/opt/wwwetc/nginx/sites-enabled", "/opt/wwwetc/nginx/certs", "/opt/wwwetc/nginx/conf.d", "/opt/wwwlogs/nginx", "/opt/wwwroot"]

# Define working directory.
# WORKDIR /etc/nginx
WORKDIR /opt/wwwetc/nginx

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80
EXPOSE 443
