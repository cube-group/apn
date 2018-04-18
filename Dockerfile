FROM php:7.1-cli-alpine

# 备份原始文件
# 修改为国内镜像源
RUN cp /etc/apk/repositories /etc/apk/repositories.bak && \
    echo "http://mirrors.aliyun.com/alpine/v3.4/main/" > /etc/apk/repositories && \
    apk update

ENV MEMCACHED_DEPS zlib-dev libmemcached-dev cyrus-sasl-dev git
RUN set -xe \
    && apk add --no-cache libmemcached-libs zlib \
    && apk add --no-cache --virtual .memcached-deps $MEMCACHED_DEPS \
    && git clone -b php7 https://github.com/php-memcached-dev/php-memcached /usr/src/php/ext/memcached \
    && docker-php-ext-configure /usr/src/php/ext/memcached \
        --disable-memcached-sasl \
    && docker-php-ext-install /usr/src/php/ext/memcached \
    && rm -rf /usr/src/php/ext/memcached \
    && apk del .memcached-deps

# pecl install yaf-3.0.6 redis-3.1.6 memcached-3.0.4
RUN cd /tmp && pecl download yaf-3.0.6 && \
    mkdir -p /tmp/yaf-3.0.6 && \
    tar -xf yaf-3.0.6.tgz -C /tmp/yaf-3.0.6 --strip-components=1 && \
    docker-php-ext-configure /tmp/yaf-3.0.6 && \
    docker-php-ext-install /tmp/yaf-3.0.6 && \
    sed -i '$a\[yaf]' /usr/local/etc/php/conf.d/docker-php-ext-yaf.ini && \
    sed -i '$a\yaf.cache_config=1' /usr/local/etc/php/conf.d/docker-php-ext-yaf.ini && \
    sed -i '$a\yaf.use_namespace=1' /usr/local/etc/php/conf.d/docker-php-ext-yaf.ini && \
    sed -i '$a\yaf.use_spl_autoload=1' /usr/local/etc/php/conf.d/docker-php-ext-yaf.ini && \
    rm -rf /tmp/yaf-*

RUN cd /tmp && pecl download redis-3.1.6 && \
    mkdir -p /tmp/redis-3.1.6 && \
    tar -xf redis-3.1.6.tgz -C /tmp/redis-3.1.6 --strip-components=1 && \
    docker-php-ext-configure /tmp/redis-3.1.6 && \
    docker-php-ext-install /tmp/redis-3.1.6 && \
    rm -rf /tmp/redis-*

RUN cd /tmp && pecl download mongodb-1.4.2 && \
    mkdir -p /tmp/mongodb-1.4.2 && \
    tar -xf mongodb-1.4.2.tgz -C /tmp/mongodb-1.4.2 --strip-components=1 && \
    docker-php-ext-configure /tmp/mongodb-1.4.2 && \
    docker-php-ext-install /tmp/mongodb-1.4.2 && \
    rm -rf /tmp/mongodb-*

RUN cd /tmp && pecl download apcu-5.1.11 && \
    mkdir -p /tmp/apcu-5.1.11 && \
    tar -xf apcu-5.1.11.tgz -C /tmp/apcu-5.1.11 --strip-components=1 && \
    docker-php-ext-configure /tmp/apcu-5.1.11 && \
    docker-php-ext-install /tmp/apcu-5.1.11 && \
    sed -i '$a\[apcu]' /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini && \
    sed -i '$a\apc.enabled=1' /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini && \
    sed -i '$a\apc.shm_size=32M' /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini && \
    sed -i '$a\apc.enable_cli=1' /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini && \
    rm -rf /tmp/apcu-*

#RUN cd /tmp \
#    && pecl download $PHP_EXT_SWOOLE \
#    && mkdir -p /tmp/$PHP_EXT_SWOOLE \
#    && tar -xf ${PHP_EXT_SWOOLE}.tgz -C /tmp/$PHP_EXT_SWOOLE --strip-components=1 \
#    && docker-php-ext-configure /tmp/$PHP_EXT_SWOOLE --enable-async-redis --enable-openssl --enable-sockets=/usr/local/include/php/ext/sockets \
#    && docker-php-ext-install /tmp/$PHP_EXT_SWOOLE \
#    && rm -rf /tmp/${PHP_EXT_SWOOLE}*

ENV NODE_VERSION 9.11.1

RUN addgroup -g 1000 node \
    && adduser -u 1000 -G node -s /bin/sh -D node \
    && apk add --no-cache \
        libstdc++ \
    && apk add --no-cache --virtual .build-deps \
        binutils-gold \
        curl \
        g++ \
        gcc \
        gnupg \
        libgcc \
        linux-headers \
        make \
        python \
  # gpg keys listed at https://github.com/nodejs/node#release-team
  && for key in \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    56730D5401028683275BD23C23EFEFE93C4CFFFE \
    77984A986EBC2AA786BC0F66B01FBB92821C587A \
  ; do \
    gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
    gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
  done \
    && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
    && curl -SLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
    && tar -xf "node-v$NODE_VERSION.tar.xz" \
    && cd "node-v$NODE_VERSION" \
    && ./configure \
    && make -j$(getconf _NPROCESSORS_ONLN) \
    && make install \
    && apk del .build-deps \
    && cd .. \
    && rm -Rf "node-v$NODE_VERSION" \
    && rm "node-v$NODE_VERSION.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt

ENV YARN_VERSION 1.5.1

RUN apk add --no-cache --virtual .build-deps-yarn curl gnupg tar \
  && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
    gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
    gpg --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
  done \
  && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && apk del .build-deps-yarn

RUN composer selfupdate