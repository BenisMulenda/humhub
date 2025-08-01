# Use PHP 8.1 with Apache
FROM php:8.1-apache

# Install system dependencies and PHP extensions
RUN apt-get update && \
    apt-get install -y unzip git libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev zip curl && \
    docker-php-ext-install pdo pdo_mysql gd mbstring xml

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy everything into container
COPY . /var/www/html

# Install Composer (dependency manager)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev --prefer-dist

# Set file permissions
RUN chown -R www-data:www-data /var/www/html

# Set Apache web root to `public/`
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf

# Expose port 80 for Railway
EXPOSE 80
