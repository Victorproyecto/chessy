FROM php:8.3-fpm

# Instalar extensiones necesarias
RUN apt-get update && apt-get install -y \
    libicu-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install intl pdo_mysql zip opcache

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copiar los archivos del proyecto
COPY . .

RUN git config --global --add safe.directory /var/www/html
# Instalar dependencias PHP con Composer
RUN composer install --no-interaction --optimize-autoloader

# Cambiar permisos para que el usuario www-data pueda escribir
RUN chown -R www-data:www-data /var/www/html/var /var/www/html/vendor

EXPOSE 9000

CMD ["php-fpm"]
