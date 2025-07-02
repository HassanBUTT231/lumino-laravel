# Use official PHP FPM image (AWS-compatible)
FROM public.ecr.aws/docker/library/php:8.2-fpm

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN apt-get update && apt-get install -y \
    git curl libpng-dev libonig-dev libxml2-dev zip unzip libzip-dev \
 && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Copy application files
COPY . .

# Copy .env or set fallback
COPY .env .env

# Create SQLite database file (optional, avoids session errors)
RUN mkdir -p database && touch database/database.sqlite

# Install Laravel dependencies and setup
RUN composer install --no-dev --optimize-autoloader || true \
 && php artisan key:generate \
 && php artisan config:cache \
 && php artisan route:cache || true

# Permissions for Laravel cache/session
RUN chown -R www-data:www-data storage bootstrap/cache \
 && chmod -R 775 storage bootstrap/cache

# Expose port
EXPOSE 8000

# Run Laravel
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
