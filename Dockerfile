FROM php:8.3-fpm

# Instalar dependencias básicas y extensiones PHP
RUN apt-get update && apt-get install -y \
    libicu-dev libzip-dev zip unzip git curl libonig-dev libxml2-dev gnupg \
    && pecl install mongodb \
    && docker-php-ext-enable mongodb \
    && docker-php-ext-install intl pdo_mysql zip opcache

# Añadir clave pública de MongoDB para el repositorio oficial
RUN curl -fsSL https://pgp.mongodb.com/server-7.0.asc | gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.gpg

# Añadir repositorio MongoDB para Debian Bookworm
RUN echo "deb [signed-by=/usr/share/keyrings/mongodb-server-7.gpg] https://repo.mongodb.org/apt/debian bookworm/mongodb-org/7.0 main" > /etc/apt/sources.list.d/mongodb-org-7.0.list

# Instalar mongo shell (mongosh)
RUN apt-get update && apt-get install -y mongodb-mongosh

# Copiar composer desde la imagen oficial
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
