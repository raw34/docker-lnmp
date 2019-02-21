#
# PHP Dockerfile
#
#

FROM php:7.2-fpm-alpine

MAINTAINER raw34 <raw34@sina.com>

WORKDIR /www

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
    python \
    make \
    gcc \
    g++ \
    git \
    openssh \
    openssl-dev \
    libc-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libmcrypt-dev \
    supervisor \
    && rm -rf /var/cache/apk/*

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install zip \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb \
    # && pecl install mcrypt-1.0.1 \
    # && docker-php-ext-enable mcrypt \
    && rm -rf /tmp/pear

# Compile phalcon
ENV PHALCON_VERSION=3.2.4

RUN cd /tmp \
    && wget https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz \
    && tar xzf v${PHALCON_VERSION}.tar.gz \
    && cd cphalcon-${PHALCON_VERSION}/build \
    && sh install \
    && docker-php-ext-enable phalcon \
    && rm -rf /tmp/v${PHALCON_VERSION}.tar.gz /tmp/cphalcon-${PHALCON_VERSION}

# Install phalcon-devtools
RUN cd /tmp \
    && wget https://github.com/phalcon/phalcon-devtools/archive/v${PHALCON_VERSION}.tar.gz \
    && tar xzf v${PHALCON_VERSION}.tar.gz \
    && cd phalcon-devtools-${PHALCON_VERSION} \
    && sh ./phalcon.sh \
    && ln -s /tmp/phalcon-devtools-${PHALCON_VERSION}/phalcon.php /usr/bin/phalcon \
    && chmod ugo+x /usr/bin/phalcon \
    && rm -rf /tmp/v${PHALCON_VERSION}.tar.gz

# Compile librdkafka && php-rdkafka
ENV LIBRDKAFKA_VERSION=0.9.5
ENV PHP_RDKAFKA_VERSION=3.0.5

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
    && echo '{"repositories": {"packagist": {"type": "composer", "url": "https://packagist.phpcomposer.com"}}}' > /root/.composer/composer.json

# Install xhgui
ENV XGUI_VERSION=1.0.4

RUN \
    cd /tmp \
    && wget https://github.com/raw34/xhgui-branch/archive/v${XGUI_VERSION}.tar.gz \
    && tar xzf v${XGUI_VERSION}.tar.gz \
    && mv xhgui-branch-${XGUI_VERSION} xhgui \
    && cd xhgui \
    && cp /tmp/xhgui/config/config.default.php /tmp/xhgui/config/config.php \
    && sed -i "s|127\.0\.0\.1|mongo|g" /tmp/xhgui/config/config.php \
    && sed -i "s|array()|array('username' => 'root', 'password' => '123456')|g" /tmp/xhgui/config/config.php \
    && chmod -R 777 /tmp/xhgui/cache \
    && composer install \
    && rm -rf /tmp/v${XGUI_VERSION}.tar.gz

# Install phpunit
ENV PHPUNIT_VERSION=7.1.5

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

# Configure PHP-FPM

EXPOSE 9000

CMD ["php-fpm"]
