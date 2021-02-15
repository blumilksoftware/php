ARG PHP_VERSION=8.0.2

FROM php:${PHP_VERSION}-fpm-alpine

ARG COMPOSER_VERSION=2.0.9

ENV COMPOSER_HOME=/application/.composer
ENV COMPOSER_MEMORY_LIMIT=-1

RUN apk update && apk upgrade \
    && apk add --no-cache icu-dev \
    && curl -sS https://getcomposer.org/installer | php -- --version="${COMPOSER_VERSION}" --install-dir=/usr/local/bin --filename=composer \
    && docker-php-ext-install mysqli pdo pdo_mysql intl \
    && docker-php-ext-enable intl
