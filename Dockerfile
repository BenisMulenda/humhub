FROM php:8.1-apache

# Install system dependencies
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
    libicu-dev \
    libjpeg62-turbo-dev \
    libjpeg-dev \
    libldap2-dev \
    libmagickwand-dev \
    libexif-dev \
    libxslt1-dev \
    imagemagick \
    libfile-fcntllock-perl \
    zip \
    g++ \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        pdo \
        pdo_mysql \
        gd \
        mbstring \
        xml \
        zip \
        exif \
        intl \
        opcache \
    && pecl install imagick apcu \
    && docker-php-ext-enable imagick apcu

# Enable Apache rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy app code into container
COPY . .

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Install PHP dependencies (ignoring platform requirements)
RUN composer install --no-dev --prefer-dist --ignore-platform-reqs || true

# Set file permissions
RUN chown -R www-data:www-data /var/www/html

# Fix Apache warnings
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Add entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["apache2-foreground"]
