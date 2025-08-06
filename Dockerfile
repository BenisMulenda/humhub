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

# Copy all files from GitHub repo into container
COPY . .

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Install PHP dependencies (optional for HumHub extensions)
RUN composer install --no-dev --prefer-dist --ignore-platform-reqs || true

# Fix file permissions
RUN chown -R www-data:www-data /var/www/html

# Suppress ServerName warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Add runtime port binding script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Run migrations from protected/yii and then start Apache
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD php protected/yii migrate/up --interactive=0 && apache2-foreground
