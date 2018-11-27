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
    autoconf \
    bash \
    busybox-extras \
    python \
    make \
    gcc \
    g++ \
    git \
    openssh \
    libc-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libmcrypt-dev \
    supervisor \
    && rm -rf /var/cache/apk/*

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install mcrypt \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql

# Install php-composer
ENV COMPOSER_VERSION=1.7.3

RUN \
    cd /tmp \
    && wget https://raw.githubusercontent.com/composer/getcomposer.org/master/web/download/${COMPOSER_VERSION}/composer.phar \
    && chmod 777 composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    && mkdir /root/.composer \
    && echo "{}" > /root/.composer/composer.json

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

# Install phalcon-devtools
RUN cd /tmp \
    && wget https://github.com/phalcon/phalcon-devtools/archive/v${PHALCON_VERSION}.tar.gz \
    && tar xzf v${PHALCON_VERSION}.tar.gz \
    && cd phalcon-devtools-${PHALCON_VERSION} \
    && sh ./phalcon.sh \
    && ln -s /tmp/phalcon-devtools-${PHALCON_VERSION}/phalcon.php /usr/bin/phalcon \
    && chmod ugo+x /usr/bin/phalcon \
    && cd ../ \
    && rm -rf v${PHALCON_VERSION}.tar.gz

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
