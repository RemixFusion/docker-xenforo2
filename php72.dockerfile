FROM php:7.2-fpm

COPY xenforo/ /var/www/html/

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN usermod --uid 1000 www-data

RUN apt-get update \
    && apt-get install unzip \
    && apt-get install -y zlib1g-dev \
    libzip-dev libgmp-dev \
    webp

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

# https://gist.github.com/shov/f34541feae29afedd93208df4bf428f3
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j "$(nproc)" gd

WORKDIR "/var/www/html"