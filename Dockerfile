FROM php:7.4-fpm-alpine as base

WORKDIR /app

RUN echo "Europe/Kiev" > /etc/timezone

# Install system PHP dependent libs
RUN apk --no-cache add \
    libpng \
    libzip \
    oniguruma \
    imap c-client \
    krb5 \
    openssl \
    libpq \
    icu-libs \
    vips \
    rabbitmq-c

RUN apk add --no-cache -t .build-deps \
    icu-dev \
    libpng-dev \
    libzip-dev \
    libxml2-dev \
    oniguruma-dev\
    imap-dev \
    krb5-dev \
    openssl-dev \
    mariadb-dev \
    php7-pear php7-dev \
    vips-tools \
    vips-dev \
    rabbitmq-c-dev \
    g++ \
    make \
    zlib \
    zlib-dev \
    re2c \
    && docker-php-source extract \
    && mkdir -p /usr/src/php/ext/xdebug \
    && curl -fsSL https://github.com/xdebug/xdebug/archive/3.0.4.tar.gz \
        | tar xvz -C /usr/src/php/ext/xdebug --strip 1 \
    && pecl install vips \
    && pecl install amqp \
    && pecl install redis \
    && docker-php-ext-enable vips \
    && docker-php-ext-enable amqp \
    && docker-php-ext-enable redis \
    && docker-php-ext-configure intl \
    && docker-php-ext-configure calendar \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install \
    xdebug \
    intl \
    zip \
    xml \
    mbstring \
    bcmath \
    pcntl \
    opcache \
    pdo pdo_mysql \
    imap \
    calendar \
    sockets \
    && docker-php-source delete \
    && apk del .build-deps

COPY entrypoint.sh /usr/local/bin/
COPY symfony.ini /usr/local/etc/php/conf.d/

ENV APP_ENV=prod \
    XDEBUG_CLIENT_HOST="host.docker.internal" \
    XDEBUG_MODE=debug

ENTRYPOINT [ "entrypoint.sh" ]

# CMD
CMD ["sh"]
