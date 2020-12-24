#
# PHP Dockerfile
#
#

FROM php:7.2-fpm-alpine

MAINTAINER raw34 <raw34@sina.com>

WORKDIR /www

RUN \
    mkdir /root/.ssh

# Install PHP-FPM extensions
RUN \
    mv /etc/apk/repositories /etc/apk/repositories.bak \
    # echo "http://mirror.tuna.tsinghua.edu.cn/alpine/latest-stable/main/" >> /etc/apk/repositories && \
    # echo "http://mirrors.ustc.edu.cn/alpine/latest-stable/main/" >> /etc/apk/repositories && \
    && echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" >> /etc/apk/repositories

RUN \
    apk add --update \
    autoconf \
    bash \
    busybox-extras \
    curl-dev \
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
    libcurl \
    libjpeg-turbo-dev \
    libpng-dev \
    linux-headers \
    make \
    re2c \
    supervisor \
    tzdata \
    && rm -rf /var/cache/apk/*

RUN \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install gmp \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install zip

# Set timezone
ENV TZ="Asia/Shanghai"

RUN \
    echo "Asia/Shanghai" > /etc/timezone

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
ENV PHP_RDKAFKA_VERSION=4.0.3
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
ENV PHP_MONGO_VERSION=1.5.3

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

# Install php-composer
ENV COMPOSER_VERSION=2.0.0

RUN \
    cd /tmp \
    && wget https://raw.githubusercontent.com/composer/getcomposer.org/master/web/download/${COMPOSER_VERSION}/composer.phar \
    && chmod 777 composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    && mkdir /root/.composer \
    && echo '{}' > /root/.composer/composer.json

# Install phpunit
ENV PHPUNIT_VERSION=7.5.20

RUN \
    cd /tmp \
    && wget https://phar.phpunit.de/phpunit-${PHPUNIT_VERSION}.phar \
    && chmod +x phpunit-${PHPUNIT_VERSION}.phar \
    && mv phpunit-${PHPUNIT_VERSION}.phar /usr/local/bin/phpunit

# Install phpunit-skelgen
RUN \
    cd /tmp \
    && wget https://phar.phpunit.de/phpunit-skelgen.phar \
    && chmod +x phpunit-skelgen.phar \
    && mv phpunit-skelgen.phar /usr/local/bin/phpunit-skelgen

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
    && sed -i 's|"suggest"|"repositories": {"packagist": {"type": "composer", "url": "https://mirrors.aliyun.com/composer"}}, "suggest"|g' /data-php7/xhgui/composer.json \
    && rm /data-php7/xhgui/composer.lock \
    && chmod -R 777 /data-php7/xhgui/cache \
    && composer install --no-dev \
    && rm -rf /data-php7/v${XGUI_VERSION}.tar.gz

VOLUME /data-php7

# Install molten
ENV MOLTEN_VERSION=0.1.1
ENV MOLTEN_ENABLE=${MOLTEN_ENABLE:-1}
ENV MOLTEN_TRACING_CLI=${MOLTEN_TRACING_CLI:-0}
ENV MOLTEN_SPAN_VERSION=${MOLTEN_SPAN_VERSION:-v1}
ENV MOLTEN_SPAN_FORMAT=${MOLTEN_SPAN_FORMAT:-zipkin}
ENV MOLTEN_SINK_TYPE=${MOLTEN_SINK_TYPE:-1}
ENV MOLTEN_SINK_HOST=${MOLTEN_SINK_HOST:-172.17.0.1}
ENV MOLTEN_SINK_PORT=${MOLTEN_SINK_PORT:-9411}

RUN \
    cd /tmp \
    && wget https://github.com/chuan-yun/Molten/archive/v${MOLTEN_VERSION}.tar.gz \
    && tar xzf v${MOLTEN_VERSION}.tar.gz \
    && cd Molten-${MOLTEN_VERSION} \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable molten \
    && echo 'molten.enable=${MOLTEN_ENABLE}' >> /usr/local/etc/php/conf.d/docker-php-ext-molten.ini \
    && echo 'molten.report_interval=5' >> /usr/local/etc/php/conf.d/docker-php-ext-molten.ini \
    && echo 'molten.tracing_cli=${MOLTEN_TRACING_CLI}' >> /usr/local/etc/php/conf.d/docker-php-ext-molten.ini \
    && echo 'molten.sampling_type=1' >> /usr/local/etc/php/conf.d/docker-php-ext-molten.ini \
    && echo 'molten.sampling_rate=1' >> /usr/local/etc/php/conf.d/docker-php-ext-molten.ini \
    && echo 'molten.span_format=${MOLTEN_SPAN_FORMAT}' >> /usr/local/etc/php/conf.d/docker-php-ext-molten.ini \
    && echo 'molten.sink_type=${MOLTEN_SINK_TYPE}' >> /usr/local/etc/php/conf.d/docker-php-ext-molten.ini \
    && echo 'molten.sink_log_path=/var/log/php/tracing' >> /usr/local/etc/php/conf.d/docker-php-ext-molten.ini \
    && echo 'molten.sink_http_uri=http://${MOLTEN_SINK_HOST}:${MOLTEN_SINK_PORT}/api/${MOLTEN_SPAN_VERSION}/spans' >> /usr/local/etc/php/conf.d/docker-php-ext-molten.ini \
    && rm -rf /tmp/v${MOLTEN_VERSION}.tar.gz /tmp/Molten-${MOLTEN_VERSION}

# Configure PHP-FPM

EXPOSE 9000

CMD ["php-fpm"]
