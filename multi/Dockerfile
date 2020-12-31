MAINTAINER raw34 <raw34@sina.com>

ENV PHP_VERSION=7-fpm-alpine
ENV NGINX_VERSION=1.19-alpine

# stage1
FROM php:${PHP_VERSION} as php

# stage2
FROM nginx:${NGINX_VERSION} as nginx

COPY --from=php /www /www