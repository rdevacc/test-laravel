# Mengambil image PHP 8 resmi dari Docker Hub
FROM php:8-fpm

# Mengatur direktori kerja di dalam container
WORKDIR /var/www/html

# Menginstal dependensi yang dibutuhkan oleh Laravel
RUN apt-get update \
    && apt-get install -y \
    libzip-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip

# Menginstal Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Menginstal ekstensi PHP yang diperlukan oleh Laravel
RUN docker-php-ext-install pdo pdo_mysql

# Menyalin file "composer.json" dan "composer.lock" ke dalam container
COPY composer.json composer.lock ./

# Menginstal dependensi proyek Laravel menggunakan Composer
RUN composer install --no-scripts --no-autoloader

# Menyalin seluruh file proyek Laravel ke dalam container
COPY . .

# Menjalankan perintah "composer dump-autoload" di dalam container
RUN composer dump-autoload

# Mengubah kepemilikan file dalam container agar sesuai dengan pengguna www-data
RUN chown -R www-data:www-data .

# Mengekspos port yang digunakan oleh aplikasi Laravel
EXPOSE 8000

# Menjalankan perintah "php artisan serve" ketika container dijalankan
CMD php artisan serve --host=0.0.0.0 --port=8000