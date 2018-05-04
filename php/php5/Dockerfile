#
# PHP Dockerfile
#
#

FROM php:5.6-fpm-alpine

MAINTAINER raw34 <raw34@sina.com>

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
    bash \
    python \
    make \
    gcc \
    g++ \
    git \
    openssh \
    libc-dev \
    autoconf \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libmcrypt-dev \
    && rm -rf /var/cache/apk/*

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql

# Install php-composer
RUN \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Compile phalcon
ENV PHALCON_VERSION=2.0.13

RUN cd /tmp \
    && wget https://github.com/phalcon/cphalcon/archive/phalcon-v${PHALCON_VERSION}.tar.gz \
    && tar xzf phalcon-v${PHALCON_VERSION}.tar.gz \
    && cd cphalcon-phalcon-v${PHALCON_VERSION}/build \
    && sh install \
    && docker-php-ext-enable phalcon \
    && cd ../.. \
    && rm -rf phalcon-v${PHALCON_VERSION}.tar.gz cphalcon-phalcon-v${PHALCON_VERSION}

# Compile librdkafka && php-rdkafka
ENV LIBRDKAFKA_VERSION=0.9.5
ENV PHP_RDKAFKA_VERSION=1.0.0

RUN \
    cd /tmp \
    && wget https://github.com/edenhill/librdkafka/archive/v${LIBRDKAFKA_VERSION}.tar.gz \
    && tar xzf v${LIBRDKAFKA_VERSION}.tar.gz \
    && cd librdkafka-${LIBRDKAFKA_VERSION} \
    && ./configure \
    && make \
    && make install \
    && wget https://github.com/arnaud-lb/php-rdkafka/archive/${PHP_RDKAFKA_VERSION}.tar.gz \
    && tar xzf ${PHP_RDKAFKA_VERSION}.tar.gz \
    && cd php-rdkafka-${PHP_RDKAFKA_VERSION} \
    && phpize \
    && ./configure \
    && make all -j 5 \
    && make install \
    && docker-php-ext-enable rdkafka \
    && cd ../.. \
    && rm -rf v${LIBRDKAFKA_VERSION}.tar.gz librdkafka-${LIBRDKAFKA_VERSION} ${PHP_RDKAFKA_VERSION}.tar.gz php-rdkafka-${PHP_RDKAFKA_VERSION}

# Install phpunit
ENV PHPUNIT_VERSION=5.7.27

RUN \
    cd /tmp \
    && wget https://phar.phpunit.de/phpunit-${PHPUNIT_VERSION}.phar \
    && chmod +x phpunit.phar \
    && mv phpunit.phar /usr/local/bin/phpunit

# Configure PHP-FPM

EXPOSE 9000

CMD ["php-fpm"]
