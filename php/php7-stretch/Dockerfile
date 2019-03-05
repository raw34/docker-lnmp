#
# PHP Dockerfile
#
#

FROM php:7.2-fpm

MAINTAINER raw34 <raw34@sina.com>

WORKDIR /www

RUN \
    mkdir /root/.ssh

RUN \
    cp /etc/apt/sources.list /etc/apt/sources.list.bak \
#    && sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list \
#    && sed -i 's|deb.debian.org|mirrors.ustc.edu.cn|g' /etc/apt/sources.list
#    && sed -i 's|security.debian.org/debian-security|mirrors.tuna.tsinghua.edu.cn/debian-security|g' /etc/apt/sources.list \
#    && sed -i 's|deb.debian.org|mirrors.tuna.tsinghua.edu.cn|g' /etc/apt/sources.list
    && sed -i 's|security.debian.org/debian-security|mirrors.aliyun.com/debian-security|g' /etc/apt/sources.list \
    && sed -i 's|deb.debian.org|mirrors.aliyun.com|g' /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
    automake \
    ca-certificates \
    bison \
    curl \
    flex \
    git \
    libcurl4-openssl-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libssl-dev \
    libtool \
    openssl \
    ssh \
    supervisor \
    uuid-dev \
    wget \
    xz-utils \
    --no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

RUN \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install zip

# Compile phalcon
ENV PHALCON_VERSION=3.4.0

RUN \
    cd /tmp \
    && wget https://github.com/phalcon/cphalcon/archive/v${PHALCON_VERSION}.tar.gz \
    && tar xzf v${PHALCON_VERSION}.tar.gz \
    && cd cphalcon-${PHALCON_VERSION}/build \
    && bash install \
    && docker-php-ext-enable phalcon \
    && rm -rf /tmp/v${PHALCON_VERSION}.tar.gz /tmp/cphalcon-${PHALCON_VERSION}

# Install phalcon-devtools
RUN \
    cd /tmp \
    && wget https://github.com/phalcon/phalcon-devtools/archive/v${PHALCON_VERSION}.tar.gz \
    && tar xzf v${PHALCON_VERSION}.tar.gz \
    && cd phalcon-devtools-${PHALCON_VERSION} \
    && bash ./phalcon.sh \
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
    && sed -i 's|"suggest"|"repositories": {"packagist": {"type": "composer", "url": "https://packagist.phpcomposer.com"}}, "suggest"|g' /data-php7/xhgui/composer.json \
    && rm /data-php7/xhgui/composer.lock \
    && chmod -R 777 /data-php7/xhgui/cache \
    && composer install --no-dev \
    && rm -rf /data-php7/v${XGUI_VERSION}.tar.gz

VOLUME /data-php7

# Install grpc
ENV PROTOBUF_VERSION=3.6.1
ENV GRPC_VERSION=1.19.0
ENV CARES_VERSION=1_15_0

RUN \
    cd /tmp \
    && wget https://github.com/grpc/grpc/archive/v${GRPC_VERSION}.tar.gz \
    && tar zxf v${GRPC_VERSION}.tar.gz \
    && wget https://github.com/c-ares/c-ares/archive/cares-${CARES_VERSION}.tar.gz \
    && tar zxf cares-${CARES_VERSION}.tar.gz \
    && rm -rf grpc-${GRPC_VERSION}/third_party/cares/cares \
    && mv c-ares-cares-${CARES_VERSION} grpc-${GRPC_VERSION}/third_party/cares/cares \
    && wget https://github.com/protocolbuffers/protobuf/archive/v${PROTOBUF_VERSION}.tar.gz \
    && tar zxf v${PROTOBUF_VERSION}.tar.gz \
    && rm -rf grpc-${GRPC_VERSION}/third_party/protobuf \
    && mv protobuf-${PROTOBUF_VERSION} grpc-${GRPC_VERSION}/third_party/protobuf

RUN \
    cd /tmp/grpc-${GRPC_VERSION}/third_party/protobuf \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install

RUN \
    cd /tmp/grpc-${GRPC_VERSION}/third_party/protobuf/php/ext/google/protobuf/ \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable protobuf

RUN \
    export LD_LIBRARY_PATH=/usr/local/lib/ \
    && cd /tmp/grpc-${GRPC_VERSION} \
    && make \
    && make install

RUN \
    cd /tmp \
    && wget https://pecl.php.net/get/grpc-${GRPC_VERSION}.tgz \
    && tar zxf grpc-${GRPC_VERSION}.tgz \
    && cd grpc-${GRPC_VERSION} \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable grpc

RUN \
    rm -rf /tmp/v${GRPC_VERSION}.tar.gz /tmp/cares-${CARES_VERSION}.tar.gz /tmp/v${PROTOBUF_VERSION}.tar.gz /tmp/grpc-${GRPC_VERSION}.tgz
#     /tmp/grpc-${GRPC_VERSION}

# Install thrift
ENV BOOST_VERSION_1=1.69.0
ENV BOOST_VERSION_2=1_69_0
ENV THRIFT_VERSION=0.11.0

RUN \
    cd /tmp \
    && wget https://dl.bintray.com/boostorg/release/${BOOST_VERSION_1}/source/boost_${BOOST_VERSION_2}.tar.gz \
    && tar xzf boost_${BOOST_VERSION_2}.tar.gz

RUN \
    cd /tmp/boost_${BOOST_VERSION_2} \
    && ./bootstrap.sh \
    && ./b2 install --prefix=/usr/local/lib/ \
    && rm -rf /tmp/boost_${BOOST_VERSION_2}.tar.gz /tmp/boost_${BOOST_VERSION_2}

RUN \
    cd /tmp \
    && wget http://mirrors.tuna.tsinghua.edu.cn/apache/thrift/${THRIFT_VERSION}/thrift-${THRIFT_VERSION}.tar.gz \
    && tar xzf thrift-${THRIFT_VERSION}.tar.gz

RUN \
    cd /tmp/thrift-${THRIFT_VERSION} \
    && ./configure CXXFLAGS="-DFORCE_BOOST_SMART_PTR" --with-cpp --with-php=no --with-python=no --with-ruby=no --with-nodejs=no --with-qt4=no --with-java=no -with-boost=/usr/local/lib/ \
    && make \
    && make install \
    && rm -rf /tmp/thrift-${THRIFT_VERSION}.tar.gz /tmp/thrift-${THRIFT_VERSION}

# Install skywalking
ENV SKYWALKING_VERSION=2.0.0
ENV SKYWALKING_PROTOS_VERSION=1.1.1

RUN \
    cd /tmp \
    && wget https://github.com/SkyAPM/SkyAPM-php-sdk/archive/${SKYWALKING_VERSION}.tar.gz \
    && tar zxf ${SKYWALKING_VERSION}.tar.gz \
    && wget https://github.com/apache/incubator-skywalking-data-collect-protocol/archive/v${SKYWALKING_PROTOS_VERSION}.tar.gz \
    && tar zxf v${SKYWALKING_PROTOS_VERSION}.tar.gz \
    && rm -rf SkyAPM-php-sdk-${SKYWALKING_VERSION}/src/protos \
    && mv incubator-skywalking-data-collect-protocol-${SKYWALKING_PROTOS_VERSION} SkyAPM-php-sdk-${SKYWALKING_VERSION}/src/protos \
    && cd SkyAPM-php-sdk-${SKYWALKING_VERSION} \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && docker-php-ext-enable skywalking \
    && echo 'skywalking.enable=1' >> /usr/local/etc/php/conf.d/docker-php-ext-skywalking.ini \
    && echo 'skywalking.version=6' >> /usr/local/etc/php/conf.d/docker-php-ext-skywalking.ini \
    && echo 'skywalking.grpc=172.17.0.1:11800' >> /usr/local/etc/php/conf.d/docker-php-ext-skywalking.ini \
    && echo 'skywalking.log_path=/tmp' >> /usr/local/etc/php/conf.d/docker-php-ext-skywalking.ini \
#    && cd src/report \
#    && make \
#    && cp report_client /usr/bin \
    && rm -rf /tmp/${SKYWALKING_VERSION}.tar.gz /tmp/v${SKYWALKING_PROTOS_VERSION}.tar.gz
#    /tmp/SkyAPM-php-sdk-${SKYWALKING_VERSION}

# Install pinpoint
ENV PINPONINT_AGENT_VERSION=0.1.1

RUN \
    cd /tmp \
    && wget http://github.com/naver/pinpoint-c-agent/archive/v${PINPONINT_AGENT_VERSION}.tar.gz \
    && tar xzf v${PINPONINT_AGENT_VERSION}.tar.gz \
    && export WITH_BOOST_PATH=/user/local/lib/ \
    && export WITH_THRIFT_PATH=/user/local/lib/ \
    && export LD_LIBRARY_PATH=$PWD/../thirdlibray/var/:$LD_LIBRARY_PATH \
    && cd pinpoint-c-agent-${PINPONINT_AGENT_VERSION}/pinpoint_php \
    && phpize \
    && ./Build.sh \
    && make install \
    && rm -rf /tmp/v${PINPONINT_AGENT_VERSION}.tar.gz pinpoint-c-agent-${PINPONINT_AGENT_VERSION}

EXPOSE 9000

CMD ["php-fpm"]
