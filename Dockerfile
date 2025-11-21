FROM php:8.4-alpine

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

ARG VARIANT="release"

ENV PHP_DEBUG_EXTENSIONS="xdebug pcov" \
    PHP_RELEASE_EXTENSIONS="\
            ev \
            gd \
            pdo \
            pdo_mysql \
            pdo_pgsql \
            zip \
            csv \
            soap \
            brotli \
            intl \
            bcmath \
            bitset \
            calendar \
            mbstring \
            mcrypt \
            mysqli \
            mongodb \
            pgsql \
            xsl \
            gmp \
            sockets \
            ftp \
            ssh2 \
            uuid \
            curl \
            redis \
            exif \
            bz2 \
            pcntl \
            opcache \
            yaml"

ENV TZ="UTC" \
    TERM=xterm-256color

RUN apk update && apk add curl \
    build-base \
    linux-headers \
    linux-pam \
    ca-certificates \
    libstdc++ \
    openssl-dev \
    binutils \
    autoconf \
    automake \
    libtool \
    pkgconf \
    gcompat \
    bash \
    python3 \
    openssh \
    alsa-lib \
    cairo \
    cups-libs \
    dbus-libs \
    eudev-libs \
    expat \
    flac \
    gdk-pixbuf \
    glib \
    libgcc \
    libjpeg-turbo \
    libpng \
    libwebp \
    libx11 \
    libxcomposite \
    libxdamage \
    libxext \
    libxfixes \
    tzdata \
    libexif \
    udev \
    xvfb \
    zlib-dev \
    chromium \
    chromium-chromedriver

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

ENV NVM_DIR=/root/.nvm
ARG NODE_VERSION=24
RUN bash -c "source $NVM_DIR/nvm.sh && nvm install $NODE_VERSION"

ENV NODE_PATH=$NVM_DIR/versions/node/$NODE_VERSION/lib/node_modules
ENV PATH=$NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH

RUN node -v && npm install -g yarn

RUN if [ "$VARIANT" = "debug" ]; then  \
      install-php-extensions $PHP_RELEASE_EXTENSIONS $PHP_DEBUG_EXTENSIONS; \
    else  \
      install-php-extensions $PHP_RELEASE_EXTENSIONS; \
    fi \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer
