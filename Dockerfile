FROM php:8.1-apache

# Install system packages and PHP extensions
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

# Enable Apache rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy all files into container
COPY . .

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Install PHP dependencies (ignoring platform requirements)
RUN composer install --no-dev --prefer-dist --ignore-platform-reqs || true

# Fix file permissions
RUN chown -R www-data:www-data /var/www/html

# Suppress Apache server name warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Add entrypoint script to bind to dynamic Railway PORT
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Entrypoint runs dynamic port config
ENTRYPOINT ["/docker-entrypoint.sh"]

# ✅ Run setup ONLY if dynamic.php (config) doesn't exist
CMD ["apache2-foreground"]




