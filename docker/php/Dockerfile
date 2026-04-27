FROM php:8.3-apache

ARG UID=1000
ARG GID=1000

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libpq-dev \
    libicu-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    zip \
    unzip \
    gnupg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (LTS) and npm
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configure and install PHP extensions required by Laravel
RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    zip \
    intl \
    opcache \
    xml \
    fileinfo

# Install and enable Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Copy Xdebug configuration
COPY xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Enable Apache mod_rewrite (required by Laravel)
RUN a2enmod rewrite

# Create an application user/group to avoid permission issues on bind-mounted files.
RUN set -eux; \
    groupadd -g "${GID}" app; \
    useradd -m -u "${UID}" -g app -s /bin/bash app

# Configure Apache workers to run as the application user.
ENV APACHE_RUN_USER=app
ENV APACHE_RUN_GROUP=app
RUN sed -ri 's/^export APACHE_RUN_USER=.*/export APACHE_RUN_USER=${APACHE_RUN_USER}/' /etc/apache2/envvars \
    && sed -ri 's/^export APACHE_RUN_GROUP=.*/export APACHE_RUN_GROUP=${APACHE_RUN_GROUP}/' /etc/apache2/envvars

# Set the DocumentRoot to /var/www/html/public (Laravel default)
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Set working directory
WORKDIR /var/www/html
