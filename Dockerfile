FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG VARIANT="release"
ARG NODE_VERSION=24
ARG TZ="UTC"

FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive
ARG VARIANT="release"
ARG NODE_VERSION=24
ARG TZ="UTC"

ENV TZ=${TZ} \
    TERM=xterm-256color

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        chromium chromium-chromedriver \
        ca-certificates curl gnupg lsb-release software-properties-common apt-transport-https \
        build-essential pkg-config autoconf automake make gcc g++ git wget unzip zip python3 python3-pip tzdata locales; \
    \
    ln -snf /usr/share/zoneinfo/"${TZ}" /etc/localtime; echo "${TZ}" > /etc/timezone; \
    \
    add-apt-repository -y ppa:ondrej/php; \
    apt-get update; \
    \
    apt-get install -y --no-install-recommends \
        php8.4-cli php8.4-fpm php8.4-dev php8.4-common php8.4-xml php8.4-mbstring \
        php8.4-intl php8.4-gd php8.4-curl php8.4-zip php8.4-bcmath \
        php8.4-mysql php8.4-pgsql php8.4-soap php8.4-xsl php8.4-gmp \
        pkg-config php-pear libssl-dev libxml2-dev zlib1g-dev \
        libzip-dev libpng-dev libjpeg-dev libwebp-dev libonig-dev ; \
    \
    curl -fsSL "https://deb.nodesource.com/setup_${NODE_VERSION}.x" | bash -; \
    apt-get update; \
    apt-get install -y --no-install-recommends nodejs; \
    \
    npm install -g yarn; \
    \
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"; \
    EXPECTED_SIG=$(curl -fsSL https://composer.github.io/installer.sig); \
    ACTUAL_SIG=$(php -r "echo hash_file('sha384','composer-setup.php');"); \
    if [ \"$EXPECTED_SIG\" != \"$ACTUAL_SIG\" ]; then \
        echo 'Composer installer corrupt'; \
        rm -f composer-setup.php; \
        exit 1; \
    fi; \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer; \
    rm -f composer-setup.php; \
    \
    php -v || true; \
    node -v || true; \
    npm -v || true; \
    composer --version || true; \
    yarn --version || true; \
    \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*