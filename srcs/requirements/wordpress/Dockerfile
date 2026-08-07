# Base OS
FROM alpine:3.23

# Copy the main shell script to image
COPY tools/main.sh /usr/local/bin/

# Add execution permissions to the main shell script
RUN chmod +x /usr/local/bin/main.sh

# Install PHP, MariaDB client and `curl`
RUN apk add --no-cache \
    mariadb-client \
	curl \
	php-fpm \
	php-mysqli \
	php-phar \
	php-mbstring \
	php-iconv

# Download WordPress Command Line Interface to install WordPress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Configure PHP-FPM to listen on port 9000 (so NGINX can reach it)
RUN sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/g' /etc/php*/php-fpm.d/www.conf

# Custom setup script to download, configure, and launch WordPress when the container boots
ENTRYPOINT ["/usr/local/bin/main.sh"]
