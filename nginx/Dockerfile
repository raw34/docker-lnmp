#
# Nginx Dockerfile
#
#

FROM alpine:3.12.0

MAINTAINER raw34 <raw34@sina.com>

RUN \
    mv /etc/apk/repositories /etc/apk/repositories.bak \
    # echo "http://mirror.tuna.tsinghua.edu.cn/alpine/latest-stable/main/" >> /etc/apk/repositories && \
    # echo "http://mirrors.ustc.edu.cn/alpine/latest-stable/main/" >> /etc/apk/repositories && \
    && echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" >> /etc/apk/repositories

RUN apk add --update \
    wget \
    gcc \
    g++ \
    git \
    make \
    pcre-dev \
    perl \
    openssl-dev \
    tzdata \
    zlib-dev \
    && rm -rf /var/cache/apk/*

# Set timezone
RUN echo "Asia/Shanghai" > /etc/timezone

# Install Nginx
ENV OPENRESTY_DIR=/usr/local/openresty
ENV OPENRESTY_VERSION=1.15.8.2
ENV NGINX_HTTP_CONCAT_VERSION=1.2.2

# Downdload
RUN \
    mkdir -p ${OPENRESTY_DIR}/modules \
    && cd ${OPENRESTY_DIR}/modules \
    && git clone git://github.com/alibaba/nginx-http-concat.git \
    && cd nginx-http-concat \
    && git checkout ${NGINX_HTTP_CONCAT_VERSION}

## Install
RUN \
    cd /tmp \
    && wget https://openresty.org/download/openresty-${OPENRESTY_VERSION}.tar.gz \
    && tar xfz openresty-${OPENRESTY_VERSION}.tar.gz \
    && cd openresty-${OPENRESTY_VERSION} \
    && ./configure --prefix=${OPENRESTY_DIR} \
        --with-luajit \
        --with-http_ssl_module \
        --with-http_iconv_module  \
        --with-http_realip_module \
        --with-http_gzip_static_module \
        --with-http_stub_status_module \
        --add-module=${OPENRESTY_DIR}/modules/nginx-http-concat/ \
    && make \
    && make install \
    && rm -rf /tmp/openresty-${OPENRESTY_VERSION}.tar.gz /tmp/openresty-${OPENRESTY_VERSION}

ENV PATH=/usr/local/openresty/nginx/sbin/:$PATH

EXPOSE 80 433

CMD ["nginx", "-g", "daemon off;"]