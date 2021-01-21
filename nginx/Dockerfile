#
# Nginx Dockerfile
#
#

FROM nginx:1.18.0-alpine AS builder

RUN \
    mv /etc/apk/repositories /etc/apk/repositories.bak \
    # echo "http://mirror.tuna.tsinghua.edu.cn/alpine/latest-stable/main/" >> /etc/apk/repositories && \
    # echo "http://mirrors.ustc.edu.cn/alpine/latest-stable/main/" >> /etc/apk/repositories && \
    && echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" >> /etc/apk/repositories

RUN apk add --no-cache --virtual .build-deps \
    gcc \
    libc-dev \
    make \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    linux-headers \
    curl \
    gnupg \
    libxslt-dev \
    gd-dev \
    geoip-dev

# Our version
ENV NGINX_VERSION=nginx-1.18.0
ENV NGINX_HTTP_CONCAT_VERSION=1.2.2

RUN \
    cd /tmp \
    && wget https://github.com/alibaba/nginx-http-concat/archive/${NGINX_HTTP_CONCAT_VERSION}.tar.gz \
    && tar xzf ${NGINX_HTTP_CONCAT_VERSION}.tar.gz

RUN \
    cd /tmp \
    CONFARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') \
    && wget https://nginx.org/download/${NGINX_VERSION}.tar.gz \
    && tar xzf ${NGINX_VERSION}.tar.gz \
    && cd ${NGINX_VERSION} \
    && ./configure --with-compat $CONFARGS --add-dynamic-module=/tmp/nginx-http-concat-${NGINX_HTTP_CONCAT_VERSION} \
    && make \
    && make install

FROM nginx:1.18.0-alpine
# Extract the dynamic module NCHAN from the builder image
COPY --from=builder /usr/local/nginx/modules/ngx_nchan_module.so /usr/local/nginx/modules/ngx_nchan_module.so

RUN \
    echo 'load_module /usr/local/nginx/modules/ngx_nchan_module.so;' > /etc/nginx/conf.d/modules.conf

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
