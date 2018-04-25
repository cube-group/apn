FROM alpine:3.7
#alpine3.7

MAINTAINER lin2798003 development "lin2798003@sina.com"

USER root

ENV APP_NAME apn
ENV APP_PATH /var/www/html
#ENV APP_MONITOR_HOOK DINGTALK-HOOK

ENV PHP_MEM_LIMIT 512M
ENV PHP_POST_MAX_SIZE 100M
ENV PHP_UPLOAD_MAX_FILESIZE 100M

RUN apk update

RUN apk add autoconf \
    dpkg-dev dpkg \
    file \
    g++ \
    gcc \
    libc-dev \
    make \
    pkgconf \
    re2c \
    curl

# php7.1.16 install
RUN apk add php7 && \
    apk add php7-curl && \
    apk add php7-mcrypt && \
    apk add php7-gettext && \
    apk add php7-gd && \
    apk add php7-dom && \
    apk add php7-json && \
    apk add php7-mbstring && \
    apk add php7-iconv && \
    apk add php7-phar && \
    apk add php7-openssl && \
    apk add php7-redis && \
    apk add php7-apcu && \
    apk add php7-amqp && \
    apk add php7-session && \
    apk add php7-pdo_mysql && \
    apk add php7-memcached && \
    apk add php7-xml && \
    apk add php7-pear && \
    apk add php7-dev && \
    cd ~ && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/bin/composer && \
    composer selfupdate

# extensions install
RUN pecl install yaf && \
    sed -i '$a\[yaf]' /etc/php7/php.ini && \
    sed -i '$a\extension=yaf.so' /etc/php7/php.ini && \
    sed -i '$a\yaf.cache_config=1' /etc/php7/php.ini && \
    sed -i '$a\yaf.use_namespace=1' /etc/php7/php.ini && \
    sed -i '$a\yaf.use_spl_autoload=1' /etc/php7/php.ini && \
    pecl install mongodb && \
    sed -i '$a\[mongodb]' /etc/php7/php.ini && \
    sed -i '$a\extension=mongodb.so' /etc/php7/php.ini && \
    sed -i '$a\[apcu]' /etc/php7/php.ini && \
    sed -i '$a\apc.enabled=1' /etc/php7/php.ini && \
    sed -i '$a\apc.shm_size=32M' /etc/php7/php.ini && \
    sed -i '$a\apc.enable_cli=1' /etc/php7/php.ini


# nodejs install
RUN apk add nodejs

# remove useless
RUN apk del php7-pear \
    php7-dev autoconf \
    dpkg-dev dpkg \
    file \
    g++ \
    gcc \
    libc-dev \
    make \
    pkgconf \
    re2c

COPY ./scripts/ /extra/
COPY ./monitor/ /extra/monitor/

WORKDIR /var/www/html

CMD ["sh","/extra/start.sh"]