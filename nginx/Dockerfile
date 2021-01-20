#
# Nginx Dockerfile
#
#

FROM alpine:3.11

MAINTAINER raw34 <raw34@sina.com>

RUN \
    mv /etc/apk/repositories /etc/apk/repositories.bak \
    # echo "http://mirror.tuna.tsinghua.edu.cn/alpine/latest-stable/main/" >> /etc/apk/repositories && \
    # echo "http://mirrors.ustc.edu.cn/alpine/latest-stable/main/" >> /etc/apk/repositories && \
    && echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" >> /etc/apk/repositories

RUN \
    echo 'nameserver 8.8.8.8' >> /etc/resolv.conf \
    echo 'nameserver 8.8.4.4' >> /etc/resolv.conf \
    echo 'codeload.github.com 13.250.162.133' >> /etc/hosts

RUN apk add --update \
    git \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    wget \
    build-base \
    tzdata \
    && rm -rf /var/cache/apk/*

# Set timezone
ENV TZ="Asia/Shanghai"

RUN \
    echo ${TZ} > /etc/timezone

# Install nginx
ENV NGINX_VERSION=nginx-1.18.0
ENV NGINX_HTTP_CONCAT_VERSION=1.2.2

RUN \
    cd /tmp \
    && wget https://github.com/alibaba/nginx-http-concat/archive/${NGINX_HTTP_CONCAT_VERSION}.tar.gz \
    && tar xzf ${NGINX_HTTP_CONCAT_VERSION}.tar.gz

RUN \
    cd /tmp \
    && wget https://nginx.org/download/${NGINX_VERSION}.tar.gz \
    && tar xzf ${NGINX_VERSION}.tar.gz \
    && cd ${NGINX_VERSION} \
    && ./configure \
        --prefix=/etc/nginx \
#        --http-log-path=/var/log/nginx/access.log \
#        --error-log-path=/var/log/nginx/error.log \
        --with-luajit \
        --with-http_ssl_module \
        --with-http_iconv_module  \
        --with-http_realip_module \
        --with-http_gzip_static_module \
        --with-http_stub_status_module \
#        --add-module=/tmp/nginx-http-concat-${NGINX_HTTP_CONCAT_VERSION} \
    && make \
    && make install \
    && rm -rf /tmp/${NGINX_VERSION}.tar.gz /tmp/${NGINX_VERSION} /tmp/${NGINX_HTTP_CONCAT_VERSION}.tar.gz /tmp/nginx-http-concat-${NGINX_HTTP_CONCAT_VERSION}

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
