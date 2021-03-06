#
# PHP Dockerfile
#
#

FROM php:7.1-fpm-alpine

MAINTAINER raw34 <raw34@sina.com>

WORKDIR /www

RUN \
    mkdir /root/.ssh

# Install PHP-FPM extensions
RUN \
    mv /etc/apk/repositories /etc/apk/repositories.bak \
     && echo "http://mirror.tuna.tsinghua.edu.cn/alpine/latest-stable/main/" >> /etc/apk/repositories
#    && echo "http://mirrors.ustc.edu.cn/alpine/latest-stable/main/" >> /etc/apk/repositories
#    && echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" >> /etc/apk/repositories

RUN \
    apk add --update --no-cache \
    autoconf \
    automake \
    bash \
    busybox-extras \
    freetype-dev \
    gcc \
    gdb \
    g++ \
    git \
    gmp \
    gmp-dev \
    openssh \
    openssl-dev \
    libc-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libtool \
    libxml2-dev \
    linux-headers \
    make \
    re2c \
    sshpass \
    supervisor \
    tzdata

RUN \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install gmp \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install soap \
    && docker-php-ext-install zip

# Set timezone
RUN \
    echo "Asia/Shanghai" > /etc/timezone

# Install nghttp2
ENV NGHTTP2_VERSION=1.42.0

RUN \
    cd /tmp \
    && wget https://github.com/tatsuhiro-t/nghttp2/archive/v${NGHTTP2_VERSION}.tar.gz \
    && tar xzf v${NGHTTP2_VERSION}.tar.gz \
    && cd nghttp2-${NGHTTP2_VERSION} \
    && autoreconf -i \
    && automake \
    && autoconf \
    && ./configure \
    && make \
    && make install \
    && rm -rf /tmp/v${NGHTTP2_VERSION}.tar.gz /tmp/nhttp2-${NGHTTP2_VERSION}

#Install curl
ENV CURL_VERSION=7.72.0

RUN \
    cd /tmp \
    && wget https://curl.haxx.se/download/curl-${CURL_VERSION}.tar.gz \
    && tar xvfz curl-${CURL_VERSION}.tar.gz \
    && cd curl-${CURL_VERSION} \
    && ./configure --with-nghttp2=/usr/local --with-ssl \
    && make \
    && make install \
    && rm -rf /tmp/v${CURL_VERSION}.tar.gz /tmp/curl-${CURL_VERSION}

# Install php-composer
ENV COMPOSER_VERSION=2.0.0

RUN \
    cd /tmp \
    && wget https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar \
    && chmod 777 composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    && mkdir /root/.composer \
    && echo '{}' > /root/.composer/composer.json

# Compile librdkafka
ENV LIBRDKAFKA_VERSION=1.5.0

RUN \
    cd /tmp \
    && wget https://github.com/edenhill/librdkafka/archive/v${LIBRDKAFKA_VERSION}.tar.gz \
    && tar xzf v${LIBRDKAFKA_VERSION}.tar.gz \
    && cd librdkafka-${LIBRDKAFKA_VERSION} \
    && ./configure \
    && make \
    && make install \
    && rm -rf /tmp/v${LIBRDKAFKA_VERSION}.tar.gz /tmp/librdkafka-${LIBRDKAFKA_VERSION}

# Compile php-rdkafka
ENV PHP_RDKAFKA_VERSION=4.0.4
RUN \
    cd /tmp \
    && wget https://github.com/arnaud-lb/php-rdkafka/archive/${PHP_RDKAFKA_VERSION}.tar.gz \
    && tar xzf ${PHP_RDKAFKA_VERSION}.tar.gz \
    && cd php-rdkafka-${PHP_RDKAFKA_VERSION} \
    && phpize \
    && ./configure \
    && make all -j 5 \
    && make install \
    && docker-php-ext-enable rdkafka \
    && rm -rf /tmp/${PHP_RDKAFKA_VERSION}.tar.gz /tmp/php-rdkafka-${PHP_RDKAFKA_VERSION}

# Compile mongodb
ENV PHP_MONGO_VERSION=1.4.1

RUN \
    cd /tmp \
    && wget https://pecl.php.net/get/mongodb-${PHP_MONGO_VERSION}.tgz \
    && tar xzf mongodb-${PHP_MONGO_VERSION}.tgz \
    && cd mongodb-${PHP_MONGO_VERSION} \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable mongodb \
    && rm -rf /tmp/mongodb-${PHP_MONGO_VERSION}.tgz /tmp/mongodb-${PHP_MONGO_VERSION}

# Compile phpredis
ENV PHP_REDIS_VERSION=3.1.3

RUN \
    cd /tmp \
    && wget https://github.com/phpredis/phpredis/archive/${PHP_REDIS_VERSION}.tar.gz \
    && tar xzf ${PHP_REDIS_VERSION}.tar.gz \
    && cd phpredis-${PHP_REDIS_VERSION} \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable redis \
    && rm -rf /tmp/${PHP_REDIS_VERSION}.tar.gz /tmp/phpredis-${PHP_REDIS_VERSION}

# Install xdebug
ENV XDEBUG_VERSION=2.7.2

RUN \
    cd /tmp \
    && wget https://pecl.php.net/get/xdebug-${XDEBUG_VERSION}.tgz \
    && tar xzf xdebug-${XDEBUG_VERSION}.tgz \
    && cd xdebug-${XDEBUG_VERSION} \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable xdebug \
    && rm -rf /tmp/xdebug-${XDEBUG_VERSION}.tgz /tmp/xdebug-${XDEBUG_VERSION}

# Compile php-xhprof
ENV PHP_XHPROF_VERSION=4.1.7

RUN \
    cd /tmp \
    && wget https://github.com/tideways/php-xhprof-extension/archive/v${PHP_XHPROF_VERSION}.tar.gz \
    && tar xzf v${PHP_XHPROF_VERSION}.tar.gz \
    && cd php-xhprof-extension-${PHP_XHPROF_VERSION} \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable tideways \
    && echo 'tideways.auto_prepend_library=0' >> /usr/local/etc/php/conf.d/docker-php-ext-tideways.ini \
    && echo 'tideways.sample_rate=100' >> /usr/local/etc/php/conf.d/docker-php-ext-tideways.ini \
    && rm -rf /tmp/v${PHP_XHPROF_VERSION}.tar.gz /tmp/php-xhprof-extension-${PHP_XHPROF_VERSION}

# Install xhgui
ENV XGUI_VERSION=1.0.4

RUN \
    mkdir /data-php7 \
    && cd /data-php7 \
    && wget https://github.com/raw34/xhgui-branch/archive/v${XGUI_VERSION}.tar.gz \
    && tar xzf v${XGUI_VERSION}.tar.gz \
    && mv xhgui-branch-${XGUI_VERSION} xhgui \
    && cd xhgui \
    && cp /data-php7/xhgui/config/config.default.php /data-php7/xhgui/config/config.php \
    && sed -i "s|'extension' => 'xhprof'|'extension' => 'tideways'|g" /data-php7/xhgui/config/config.php \
    && sed -i "s|127\.0\.0\.1|mongo|g" /data-php7/xhgui/config/config.php \
    && sed -i "s|array()|array('username' => 'root', 'password' => '123456')|g" /data-php7/xhgui/config/config.php \
    && sed -i 's|"pimple/pimple"|"alcaeus/mongo-php-adapter": "^1.0", "pimple/pimple"|g' /data-php7/xhgui/composer.json \
    && sed -i 's|"phpunit/phpunit": "3.7.x-dev",||g' /data-php7/xhgui/composer.json \
#    && sed -i 's|"suggest"|"repositories": {"packagist": {"type": "composer", "url": "https://mirrors.aliyun.com/composer"}}, "suggest"|g' /data-php7/xhgui/composer.json \
    && rm /data-php7/xhgui/composer.lock \
    && chmod -R 777 /data-php7/xhgui/cache \
    && composer install -vvv --no-dev \
    && rm -rf /data-php7/v${XGUI_VERSION}.tar.gz

# Install yac
ENV YAC_VERSION=2.2.1

RUN \
    cd /tmp \
    && wget https://github.com/laruence/yac/archive/yac-${YAC_VERSION}.tar.gz \
    && tar xzf yac-${YAC_VERSION}.tar.gz \
    && cd yac-yac-${YAC_VERSION} \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable yac \
    && rm -rf /tmp/yac-${YAC_VERSION}.tar.gz /tmp/yac-yac-${YAC_VERSION}

# Install zookeeper
ENV ZOOKEEPER_VERSION=0.6.4

RUN \
    cd /tmp \
    && echo "http://mirrors.tuna.tsinghua.edu.cn/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add libzookeeper-dev \
    && wget https://github.com/php-zookeeper/php-zookeeper/archive/v${ZOOKEEPER_VERSION}.tar.gz \
    && tar xzf v${ZOOKEEPER_VERSION}.tar.gz \
    && cd php-zookeeper-${ZOOKEEPER_VERSION} \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable zookeeper \
    && rm -rf /tmp/v${ZOOKEEPER_VERSION}.tar.gz /tmp/php-zookeeper-${ZOOKEEPER_VERSION}

# Install ip2region
ENV IP2REGION_VERSION=2.2.0-release

RUN \
    cd /tmp \
    && wget https://github.com/lionsoul2014/ip2region/archive/v${IP2REGION_VERSION}.tar.gz \
    && tar xzf v${IP2REGION_VERSION}.tar.gz \
    && cp ip2region-${IP2REGION_VERSION}/data/ip2region.db /usr/local/lib/php/extensions \
    && cp ip2region-${IP2REGION_VERSION}/binding/c/* ip2region-${IP2REGION_VERSION}/binding/php7_ext/lib \
    && cd ip2region-${IP2REGION_VERSION}/binding/php7_ext \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable ip2region \
    && echo 'ip2region.db_file=/usr/local/lib/php/extensions/ip2region.db' >> /usr/local/etc/php/conf.d/docker-php-ext-ip2region.ini \
    && rm -rf /tmp/v${IP2REGION_VERSION}.tar.gz /tmp/ip2region-${IP2REGION_VERSION}

VOLUME /data-php7

# Configure PHP-FPM

EXPOSE 9000

CMD ["php-fpm"]
