ARG PHP_VERSION=8.2.10-fpm-alpine
ARG COMPOSER_TAG_VERSION=2.6.3-bin

FROM composer/composer:${COMPOSER_TAG_VERSION} AS composer_binary

FROM php:${PHP_VERSION}

COPY --from=composer_binary /composer /usr/bin/composer

ENV COMPOSER_HOME=/application/.composer
ENV COMPOSER_MEMORY_LIMIT=-1

RUN apk update && apk upgrade \
    && apk add --no-cache icu-dev \
    && docker-php-ext-install \
        mysqli \
        pdo \
        pdo_mysql
