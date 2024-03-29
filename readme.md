![GitHub release (latest by date)](https://img.shields.io/github/v/release/blumilksoftware/php?style=for-the-badge) ![GitHub](https://img.shields.io/github/license/blumilksoftware/php?style=for-the-badge)

# blumilksoftware/php
PHP Docker image for internal **[@blumilksoftware](https://github.com/blumilksoftware)** development.

## Versioning
We are releasing images based on PHP image version numbering. For example `blumilksoftware/php:8.0.2.1` and `blumilksoftware/php:8.0.2.2` are both using `php:8.0.2-fpm-alpine`, but Composer version, installed extensions and other things can be different.

## Usage
Just put service into your `docker-compose.yml`:
```yaml
  php:
    image: ghcr.io/blumilksoftware/php:$VERSION
    container_name: project-php
    working_dir: /application
    user: ${CURRENT_UID}
    volumes:
      - .:/application
    restart: unless-stopped
```

### Extended usage
If you want, you can extend the provided configuration as follows:
```yaml
  php:
    build:
      context: ./environment/php
      dockerfile: Dockerfile
      args:
        XDEBUG_HOST: ${XDEBUG_HOST}
        XDEBUG_PORT: ${XDEBUG_PORT}
        XDEBUG_INSTALL: ${XDEBUG_INSTALL}
        XDEBUG_START_WITH_REQUEST: ${XDEBUG_START_WITH_REQUEST}
        XDEBUG_MODE: ${XDEBUG_MODE}
        XDEBUG_LOG_LEVEL: ${XDEBUG_LOG_LEVEL}
    container_name: project-php
    working_dir: /application
    user: ${CURRENT_UID}
    volumes:
      - .:/application
    restart: unless-stopped
```
where `./environment/php/Dockerfile` will be:
```dockerfile
ARG VERSION=8.1
FROM ghcr.io/blumilksoftware/php:${VERSION}

ARG XDEBUG_VERSION=3.1.2
ARG XDEBUG_HOST=172.17.0.1
ARG XDEBUG_PORT=9003
ARG XDEBUG_INSTALL=false
ARG XDEBUG_MODE=debug
ARG XDEBUG_START_WITH_REQUEST=yes
ARG XDEBUG_LOG_LEVEL=0

RUN if [ ${XDEBUG_INSTALL} = true ]; then \
    apk --no-cache add $PHPIZE_DEPS \
    && pecl install xdebug-${XDEBUG_VERSION} \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.client_host=${XDEBUG_HOST}" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.client_port=${XDEBUG_PORT}" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.mode=${XDEBUG_MODE}" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.start_with_request=${XDEBUG_START_WITH_REQUEST}" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.log_level=${XDEBUG_LOG_LEVEL}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
;fi
```
#### Change Composer version
If you would like to use a different version of the Composer, you can override it in the Dockerfile:
```dockerfile
ARG PHP_VERSION=8.1
ARG COMPOSER_TAG_VERSION=2.2

FROM composer:${COMPOSER_TAG_VERSION} as composer
FROM ghcr.io/blumilksoftware/php:${PHP_VERSION}

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

# the rest of Dockerfile
```
## Notes
Please remember to add `.composer` directory of your project to `.gitignore` list. This directory is used to Composer cache actions and it should not be pushed to any repository.
