FROM php:8.3-fpm-alpine

ARG DOCKER_UID

RUN set -eux; \
    apk update; \
    apk add --virtual .tmp-deps \
        linux-headers \
        autoconf \
        freetype-dev \
        g++ \
        libjpeg-turbo-dev \
        libpng-dev \
        libxml2-dev \
        libzip-dev \
        make \
    ; \
    apk add \
        mysql-client \
        libintl \
        icu \
        icu-dev \
        icu-data-full \
        musl-locales \
        musl-locales-lang \
    ; \
    pecl update-channels; \
    pecl install apcu; \
    rm -rf /tmp/pear; \
    \
    docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
    ; \
    \
    docker-php-ext-install -j$(nproc) gd intl opcache pcntl mysqli pdo_mysql zip; \
    \
    apk del .tmp-deps; \
    rm -rf /var/cache/apk

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

USER www-data

WORKDIR /var/www

EXPOSE 9000
