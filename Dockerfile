FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git unzip libpq-dev libzip-dev zip curl \
    libonig-dev libxml2-dev libicu-dev \
    libjpeg-dev libpng-dev libfreetype6-dev \
    libmcrypt-dev libssl-dev libxrender1 libfontconfig1 \
    && docker-php-ext-install pdo pdo_pgsql intl zip opcache

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000
