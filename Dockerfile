# Use the official PHP 8.0 image as the base image
FROM php:8.0-fpm

# Install required extensions and dependencies
RUN apt-get update \
    && apt-get install -y \
       git \
       unzip \
       libzip-dev \
    && docker-php-ext-install pdo_mysql zip

# Copy the application code to the container
COPY . /var/www/html

# Set the working directory
WORKDIR /var/www/html

# Install Composer and project dependencies
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install --optimize-autoloader --no-dev

# Set appropriate permissions
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html/storage

# Expose port 80 (or any other port your Laravel application listens on)
EXPOSE 80

# Start PHP-FPM server
CMD ["php-fpm"]
