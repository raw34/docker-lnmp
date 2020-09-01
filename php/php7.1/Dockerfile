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
    # && pecl install mcrypt-1.0.1 \
    # && docker-php-ext-enable mcrypt

# Set timezone
ENV TZ="Asia/Shanghai"

RUN \
    echo "Asia/Shanghai" > /etc/timezone

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

# Install php-composer
ENV COMPOSER_VERSION=1.7.3

RUN \
    cd /tmp \
    && wget https://raw.githubusercontent.com/composer/getcomposer.org/master/web/download/${COMPOSER_VERSION}/composer.phar \
    && chmod 777 composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    && mkdir /root/.composer \
    && echo '{}' > /root/.composer/composer.json

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
    && composer install -vvv --no-dev \
    && rm -rf /data-php7/v${XGUI_VERSION}.tar.gz

VOLUME /data-php7

# Configure PHP-FPM

EXPOSE 9000

CMD ["php-fpm"]
