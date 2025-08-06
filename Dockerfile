FROM php:8.1-apache

# Install system packages and required PHP extensions
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip && \
    docker-php-ext-install pdo pdo_mysql gd mbstring xml zip

# Enable Apache rewrite module
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy all files
COPY . .

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Install PHP dependencies (ignore platform compatibility)
RUN composer install --no-dev --prefer-dist --ignore-platform-reqs || true

# Fix permissions
RUN chown -R www-data:www-data /var/www/html

# Suppress Apache FQDN warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# ✅ Make Apache listen on Railway's dynamic port
RUN sed -i "s/80/\${PORT}/g" /etc/apache2/ports.conf && \
    sed -i "s/:80/:${PORT}/g" /etc/apache2/sites-available/000-default.conf

# Start Apache
CMD ["apache2-foreground"]
