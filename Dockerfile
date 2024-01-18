# Use an official PHP image with composer installed as a base image
FROM composer as builder

# Copy the app code to the container
COPY . /app

# Set the working directory
WORKDIR /app

# Run composer install to install the dependencies
RUN composer install
RUN cp .env.example .env
RUN php saya key

# Use an official PHP image with PHP-FPM and Nginx as a base image
FROM php:8-fpm

# Install Nginx
RUN apt-get update && apt-get install -y nginx

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/sites-enabled/default

# Copy the app code from the builder container
COPY --from=builder /app /var/www/html

# Copy the vendor directory from the builder container
COPY --from=builder /app/vendor /var/www/html/vendor

# Expose port 80
EXPOSE 80

# Start Nginx and PHP-FPM
CMD service nginx start && php-fpm
