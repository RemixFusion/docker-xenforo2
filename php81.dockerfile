FROM php:8.1.6-fpm

COPY xenforo/ /var/www/html/

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN usermod --uid 1000 www-data

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      unzip zlib1g-dev libzip-dev libgmp-dev \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libpng-dev \
      libjpeg-dev \
      libmagickwand-dev

RUN docker-php-ext-install mysqli \
	&& docker-php-ext-install pdo_mysql \
	&& docker-php-ext-install zip

# XenForo2 required extension GMP
RUN docker-php-ext-configure gmp && docker-php-ext-install gmp

# PHP 8 does not include pecl so switch to new module manager pickle
RUN curl -L --output /tmp/pickle.phar https://github.com/FriendsOfPHP/pickle/releases/download/v0.7.11/pickle.phar \
    && mv /tmp/pickle.phar /usr/local/bin/pickle \
    && chmod +x /usr/local/bin/pickle

# PHP 8 does not include pecl so switch to new module manager pickle
RUN curl -L --output /tmp/pickle.phar https://github.com/FriendsOfPHP/pickle/releases/download/v0.7.11/pickle.phar \
    && mv /tmp/pickle.phar /usr/local/bin/pickle \
    && chmod +x /usr/local/bin/pickle

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j "$(nproc)" gd

RUN pickle install imagick && docker-php-ext-enable imagick
RUN pickle install redis && docker-php-ext-enable redis

WORKDIR "/var/www/html"