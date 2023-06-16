# Gunakan base image resmi PHP dengan versi yang diinginkan
FROM php:8.0-apache

# Install dependensi yang dibutuhkan oleh Laravel
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    libonig-dev \
    libxml2-dev \
    mariadb-client \
    libmagickwand-dev --no-install-recommends

# Enable mod_rewrite untuk Apache
RUN a2enmod rewrite

# Install PHP extensions yang dibutuhkan oleh Laravel
RUN docker-php-ext-install zip mbstring exif pcntl bcmath gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Salin file composer.json dan composer.lock untuk menginstal dependensi PHP
COPY composer.json composer.lock /var/www/

# Set direktori kerja
WORKDIR /var/www

# Install dependensi PHP dengan Composer
RUN composer install --no-scripts --no-autoloader

# Salin kode sumber Laravel
COPY . /var/www

# Generate autoload file dan kunci aplikasi
RUN composer dump-autoload && \
    php artisan key:generate

# Berikan hak akses yang sesuai pada direktori penyimpanan
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Expose port yang digunakan oleh aplikasi Laravel
EXPOSE 80

# Jalankan Apache di foreground saat kontainer dimulai
CMD ["apache2-foreground"]
