FROM php:8.1-fpm-alpine

# Install PHP extensions and nginx
RUN docker-php-ext-install pdo pdo_mysql && \
    apk add --no-cache nginx supervisor mysql-client

# Copy PHP files
COPY Student_login/ /var/www/html/

# Copy nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Copy supervisor config
COPY supervisord.conf /etc/supervisord.conf

# Create nginx directories
RUN mkdir -p /var/log/nginx /var/lib/nginx/tmp

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]