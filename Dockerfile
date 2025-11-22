FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG VARIANT="release"
ARG NODE_VERSION=24
ARG TZ="UTC"

RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common \
 && add-apt-repository -y ppa:ondrej/php \
 && apt-get update

RUN apt-get update && apt-get install -y --no-install-recommends \
        php8.4-cli php8.4-fpm php8.4-dev php8.4-common php8.4-xml php8.4-mbstring \
        php8.4-intl php8.4-gd php8.4-curl php8.4-zip php8.4-bcmath \
        php8.4-mysql php8.4-pgsql php8.4-soap php8.4-xsl php8.4-gmp \
        pkg-config php-pear php8.4-dev libssl-dev libxml2-dev zlib1g-dev \
        libzip-dev libpng-dev libjpeg-dev libwebp-dev libonig-dev \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get update && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g yarn

RUN set -eux; \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
    EXPECTED_SIG=$(curl -fsSL https://composer.github.io/installer.sig); \
    ACTUAL_SIG=$(php -r "echo hash_file('sha384','composer-setup.php');"); \
    if [ "$EXPECTED_SIG" != "$ACTUAL_SIG" ]; then \
        echo 'Composer installer corrupt'; \
        rm composer-setup.php; \
        exit 1; \
    fi; \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
    rm -f composer-setup.php

RUN php -v || true
RUN node -v || true
RUN npm -v || true
RUN composer --version || true
RUN yarn --version || true