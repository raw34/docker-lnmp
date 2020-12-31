# stage1
FROM php:7-fpm-alpine as php

MAINTAINER raw34 <raw34@sina.com>

WORKDIR /www

# stage2
FROM nginx:1.19-alpine as nginx

MAINTAINER raw34 <raw34@sina.com>

COPY --from=php /www /www