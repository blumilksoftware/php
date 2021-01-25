FROM php:8.0.1-fpm-alpine

ENV COMPOSER_HOME=/application/.composer
ENV COMPOSER_MEMORY_LIMIT=-1

RUN apk update && apk upgrade \
    && apk add --no-cache icu-dev \
    && curl -sS https://getcomposer.org/installer | php --  --version=2.0.8 --install-dir=/usr/local/bin --filename=composer \
    && docker-php-ext-install mysqli pdo pdo_mysql intl \
    && docker-php-ext-enable intl