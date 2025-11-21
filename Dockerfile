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

RUN if [ "$VARIANT" = "debug" ]; then  \
      install-php-extensions $PHP_RELEASE_EXTENSIONS $PHP_DEBUG_EXTENSIONS; \
    else  \
      install-php-extensions $PHP_RELEASE_EXTENSIONS; \
    fi \
    && apk add nodejs-current \
               npm \
               openssh  \
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
               chromium-chromedriver \
    && npm install -g yarn