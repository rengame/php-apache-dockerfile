FROM php:7.2-apache
RUN docker-php-ext-install -j$(nproc) pdo_mysql \
    && pecl install redis-3.1.6 \
    && pecl install xdebug \
    && docker-php-ext-enable redis xdebug \
    && docker-php-source delete \
    && mkdir -p /data/logs

RUN apt-get update \
    && apt-get install -y libmemcached-dev zlib1g-dev \
    && pecl install memcached \
    && docker-php-ext-enable memcached

RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && rm -rf /var/lib/apt/lists/*


# INSTALL memcached
#RUN apt-get update \
#    && apt-get install -y libmemcached-dev zlib1g-dev libicu-dev \
#    && curl -L https://github.com/php-memcached-dev/php-memcached/archive/v3.1.3.tar.gz -o /usr/local/src/memcached-v3.1.3.tar.gz \
#    && tar -zxvf /usr/local/src/memcached-v3.1.3.tar.gz \
#    && docker-php-ext-configure /usr/local/src/php-memcached-3.1.3 \
#    --disable-memcached-sasl \
#    && docker-php-ext-install /usr/local/src/php-memcached-3.1.3 \
#    && rm -rf /usr/local/src/php-memcached-3.1.3 /usr/local/src/memcached-v3.1.3.tar.gz

COPY etc /usr/local/etc
