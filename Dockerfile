FROM php:8.1-apache

RUN apt-get update && apt-get install -y \
    unzip git curl libpng-dev libjpeg-dev libfreetype6-dev \
    libonig-dev libxml2-dev zip libicu-dev \
    libexif-dev imagemagick \
    && docker-php-ext-configure gd --with-jpeg --with-freetype \
    && docker-php-ext-install pdo pdo_mysql gd mbstring xml intl exif

RUN a2enmod rewrite

WORKDIR /var/www/html

COPY . /var/www/html

RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

RUN composer install --no-dev --prefer-dist --ignore-platform-reqs

RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

CMD ["apache2-foreground"]
