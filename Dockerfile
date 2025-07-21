FROM php:8.3-fpm

RUN apt-get update && apt-get install -y \
    libicu-dev libzip-dev zip unzip git curl libonig-dev libxml2-dev \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb \
    && docker-php-ext-install intl pdo_mysql zip opcache

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

RUN chmod +x bin/console

RUN composer install --no-interaction --optimize-autoloader

RUN git config --global --add safe.directory /var/www/html

RUN chown -R www-data:www-data /var/www/html/var /var/www/html/vendor
RUN chmod -R 775 /var/www/html/var/cache

EXPOSE 9000

CMD ["php-fpm"]
