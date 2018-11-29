#
# Nginx Dockerfile
#

# Pull base image.
FROM nginx:alpine

MAINTAINER raw34 <raw34@sina.com>

# Configure Nginx
COPY nginx.conf /etc/nginx/
COPY php5-localhost.conf /etc/nginx/sites-available/
COPY php7-localhost.conf /etc/nginx/sites-available/

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80
EXPOSE 443
