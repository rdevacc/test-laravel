# Menggunakan image PHP 8.0 dengan modul yang dibutuhkan oleh Laravel
FROM php:8.0-fpm

# Set direktori kerja aplikasi Laravel
WORKDIR /var/www/html

# Install dependensi yang diperlukan oleh Laravel
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libonig-dev \
    libxml2-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libwebp-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libssl-dev \
    libicu-dev \
    libxslt1-dev \
    libyaml-dev \
    libsqlite3-dev \
    && docker-php-ext-install \
    bcmath \
    ctype \
    fileinfo \
    json \
    mbstring \
    pdo \
    pdo_mysql \
    pdo_sqlite \
    simplexml \
    tokenizer \
    xml \
    xmlwriter \
    xsl \
    zip \
    opcache \
    && pecl install -o -f redis \
    && pecl install mongodb \
    && docker-php-ext-enable redis mongodb

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy kode aplikasi Laravel ke dalam image Docker
COPY . .

# Install dependensi Laravel menggunakan Composer
RUN composer install --no-scripts --no-autoloader && \
    composer dump-autoload --optimize

# Set permission agar Laravel dapat menulis file log dan cache
RUN chown -R www-data:www-data storage bootstrap/cache

# Jalankan per
