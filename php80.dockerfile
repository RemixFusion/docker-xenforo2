FROM php:8.0.8-fpm

COPY xenforo/ /var/www/html/

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN usermod --uid 1000 www-data

RUN apt-get update \
    && apt-get install unzip \
    && apt-get install -y zlib1g-dev \
    && apt-get install -y libzip-dev libgmp-dev \
    && apt-get install -y ffmpeg

RUN docker-php-ext-install mysqli \ 
	&& docker-php-ext-install pdo_mysql \
	&& docker-php-ext-install zip

# XenForo2 required extension GMP
RUN docker-php-ext-configure gmp && docker-php-ext-install gmp

# install php GD & Imagick ext
RUN apt-get install -y --no-install-recommends \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    zlib1g-dev \
    libpng-dev \
    libjpeg-dev \
    libmagickwand-dev

# PHP 8 does not include pecl so switch to new module manager pickle
RUN curl -L --output /tmp/pickle.phar https://github.com/FriendsOfPHP/pickle/releases/download/v0.7.11/pickle.phar \
    && mv /tmp/pickle.phar /usr/local/bin/pickle \
    && chmod +x /usr/local/bin/pickle

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j "$(nproc)" gd

# install imagick
# use github version for now until release from https://pecl.php.net/get/imagick is ready for PHP 8
RUN mkdir -p /usr/src/php/ext/imagick; \
    curl -fsSL https://github.com/Imagick/imagick/archive/448c1cd0d58ba2838b9b6dff71c9b7e70a401b90.tar.gz | tar xvz -C "/usr/src/php/ext/imagick" --strip 1; \
    docker-php-ext-install imagick

WORKDIR "/var/www/html"