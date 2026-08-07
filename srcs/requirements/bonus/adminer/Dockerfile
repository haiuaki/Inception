# Base OS
FROM alpine:3.23

# Install PHP and database extensions required by Adminer
RUN apk add --no-cache \
    php84 \
    php84-session \
    php84-mysqli \
    php84-pdo_mysql \
    wget

# Create the directory for the web server
RUN mkdir -p /var/www/adminer

# Download the official Adminer standalone PHP file and rename it to index.php
RUN wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php \
    -O /var/www/adminer/index.php

# Secure the permissions
RUN chown -R nobody:nobody /var/www/adminer

# Expose port 8080 for the internal network
EXPOSE 8080

# Launch PHP's built-in ultra-lightweight web server in the foreground
CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/adminer"]
