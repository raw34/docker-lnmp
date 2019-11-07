#
# PHP Dockerfile
#
#

FROM php:5.6-fpm-alpine

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
    libmcrypt-dev \
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
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install zip

# Set timezone
ENV TZ="Asia/Shanghai"

RUN \
    echo "Asia/Shanghai" > /etc/timezone

# Compile phalcon
ENV PHALCON_VERSION=2.0.13

RUN \
    cd /tmp \
    && wget https://github.com/phalcon/cphalcon/archive/phalcon-v${PHALCON_VERSION}.tar.gz \
    && tar xzf phalcon-v${PHALCON_VERSION}.tar.gz \
    && cd cphalcon-phalcon-v${PHALCON_VERSION}/build \
    && sh install \
    && docker-php-ext-enable phalcon \
    && rm -rf /tmp/phalcon-v${PHALCON_VERSION}.tar.gz /tmp/cphalcon-phalcon-v${PHALCON_VERSION}

# Install phalcon-devtools
RUN \
    cd /tmp \
    && wget https://github.com/phalcon/phalcon-devtools/archive/v${PHALCON_VERSION}.tar.gz \
    && tar xzf v${PHALCON_VERSION}.tar.gz \
    && cd phalcon-devtools-${PHALCON_VERSION} \
    && sh ./phalcon.sh \
    && ln -s /tmp/phalcon-devtools-${PHALCON_VERSION}/phalcon.php /usr/bin/phalcon \
    && chmod ugo+x /usr/bin/phalcon \
    && rm -rf /tmp/v${PHALCON_VERSION}.tar.gz

# Compile librdkafka && php-rdkafka
ENV LIBRDKAFKA_VERSION=0.9.2
ENV PHP_RDKAFKA_VERSION=3.0.0

RUN \
    cd /tmp \
    && wget https://github.com/edenhill/librdkafka/archive/v${LIBRDKAFKA_VERSION}.tar.gz \
    && tar xzf v${LIBRDKAFKA_VERSION}.tar.gz \
    && cd librdkafka-${LIBRDKAFKA_VERSION} \
    && ./configure \
    && make \
    && make install \
    && cd /tmp \
    && wget https://github.com/arnaud-lb/php-rdkafka/archive/${PHP_RDKAFKA_VERSION}.tar.gz \
    && tar xzf ${PHP_RDKAFKA_VERSION}.tar.gz \
    && cd php-rdkafka-${PHP_RDKAFKA_VERSION} \
    && phpize \
    && ./configure \
    && make all -j 5 \
    && make install \
    && docker-php-ext-enable rdkafka \
    && rm -rf /tmp/v${LIBRDKAFKA_VERSION}.tar.gz /tmp/librdkafka-${LIBRDKAFKA_VERSION} /tmp/${PHP_RDKAFKA_VERSION}.tar.gz /tmp/php-rdkafka-${PHP_RDKAFKA_VERSION}

# Compile mongo
ENV PHP_MONGO_VERSION=1.6.16

RUN \
    cd /tmp \
    && wget https://pecl.php.net/get/mongo-${PHP_MONGO_VERSION}.tgz \
    && tar xzf mongo-${PHP_MONGO_VERSION}.tgz \
    && cd mongo-${PHP_MONGO_VERSION} \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && echo 'extension=mongo.so' >> /usr/local/etc/php/conf.d/docker-php-ext-mongo.ini \
    && rm -rf /tmp/mongo-${PHP_MONGO_VERSION}.tgz /tmp/mongo-${PHP_MONGO_VERSION}

# Compile php-xhprof
ENV PHP_XHPROF_VERSION=4.0.3

RUN \
    cd /tmp \
    && wget https://github.com/tideways/php-xhprof-extension/archive/v${PHP_XHPROF_VERSION}.tar.gz \
    && tar xzf v${PHP_XHPROF_VERSION}.tar.gz \
    && cd php-xhprof-extension-${PHP_XHPROF_VERSION} \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && echo 'extension=tideways.so' >> /usr/local/etc/php/conf.d/docker-php-ext-tideways.ini \
    && echo 'tideways.auto_prepend_library=0' >> /usr/local/etc/php/conf.d/docker-php-ext-tideways.ini \
    && echo 'tideways.sample_rate=100' >> /usr/local/etc/php/conf.d/docker-php-ext-tideways.ini \
    && rm -rf /tmp/v${PHP_XHPROF_VERSION}.tar.gz /tmp/php-xhprof-extension-${PHP_XHPROF_VERSION}

# Install php-composer
ENV COMPOSER_VERSION=1.7.3

RUN \
    cd /tmp \
    && wget https://raw.githubusercontent.com/composer/getcomposer.org/master/web/download/${COMPOSER_VERSION}/composer.phar \
    && chmod 777 composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    && mkdir /root/.composer \
    && echo '{}' > /root/.composer/composer.json

# Install phpunit
ENV PHPUNIT_VERSION=5.7.27

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

# Install xhgui
ENV XGUI_VERSION=1.0.4

RUN \
    mkdir /data-php5 \
    && cd /data-php5 \
    && wget https://github.com/raw34/xhgui-branch/archive/v${XGUI_VERSION}.tar.gz \
    && tar xzf v${XGUI_VERSION}.tar.gz \
    && mv xhgui-branch-${XGUI_VERSION} xhgui \
    && cd xhgui \
    && cp /data-php5/xhgui/config/config.default.php /data-php5/xhgui/config/config.php \
    && sed -i "s|'extension' => 'xhprof'|'extension' => 'tideways'|g" /data-php5/xhgui/config/config.php \
    && sed -i "s|127\.0\.0\.1|mongo|g" /data-php5/xhgui/config/config.php \
    && sed -i "s|array()|array('username' => 'root', 'password' => '123456')|g" /data-php5/xhgui/config/config.php \
    && sed -i 's|"phpunit/phpunit": "3.7.x-dev",||g' /data-php5/xhgui/composer.json \
    && sed -i 's|"suggest"|"repositories": {"packagist": {"type": "composer", "url": "https://mirrors.aliyun.com/composer"}}, "suggest"|g' /data-php5/xhgui/composer.json \
    && chmod -R 777 /data-php5/xhgui/cache \
    && composer install --no-dev \
    && rm -rf /data-php5/v${XGUI_VERSION}.tar.gz

VOLUME /data-php5

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

# Install xdebug
ENV XDEBUG_VERSION=2.5.5

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

# Configure PHP-FPM

EXPOSE 9000

CMD ["php-fpm"]
