FROM php:8.1-apache

# Install system packages and PHP extensions
RUN apt-get update && \
    apt-get install -y unzip git curl libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev zip && \
    docker-php-ext-install pdo pdo_mysql gd mbstring xml

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy project files into container
COPY . /var/www/html

# Install Composer manually
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Run Composer install
RUN composer install --no-dev --prefer-dist

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Set web root to public/
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf

EXPOSE 80
