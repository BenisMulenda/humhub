FROM php:8.1-apache

# Install system dependencies and PHP extensions
RUN apt-get update && \
    apt-get install -y unzip git curl libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev zip && \
    docker-php-ext-install pdo pdo_mysql gd mbstring xml

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy all files into container
COPY . /var/www/html

# Install Composer manually
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Install PHP dependencies
RUN composer install --no-dev --prefer-dist --ignore-platform-reqs

# ✅ Rewrite Apache config to use Railway's dynamic $PORT
RUN sed -i "s/80/\${PORT}/g" /etc/apache2/ports.conf && \
    sed -i "s/:80/:${PORT}/g" /etc/apache2/sites-available/000-default.conf

# Fix permissions
RUN chown -R www-data:www-data /var/www/html

# Start Apache
CMD ["apache2-foreground"]
