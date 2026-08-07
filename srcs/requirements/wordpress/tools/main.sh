#!/bin/sh

echo "Waiting for MariaDB to boot..."

# Using the mariadb-client to attempt to log into the database and ask a math question
while ! mariadb -h \
	mariadb \
	-u ${DB_USER} \
	-p$(cat /run/secrets/db_password) ${DB_NAME} \
	-e "SELECT 1;" > /dev/null 2>&1; do
	sleep 3
done
echo "MariaDB is online and ready."

# Navigate to the Docker Volume mount point
cd /var/www/html

if [ ! -f "wp-config.php" ]; then
	echo "Downloading WordPress Core..."

	# Temporarily increase PHP's safety memory limit for download
	php -d memory_limit=512M /usr/local/bin/wp core download

	echo "Configuring Database Connection..."
	# Generates a `wp-config.php` using Secrets and `.env` variables
	wp config create \
		--allow-root \
		--dbname="${DB_NAME}" \
		--dbuser="${DB_USER}" \
		--dbpass="$(cat /run/secrets/db_password)" \
		--dbhost="mariadb:3306"

	echo "Installing WordPress Website..."

	# Install the actual website and creates the Administrator account
	wp core install \
		--allow-root \
		--url="https://${DOMAIN_NAME}" \
		--title="${WP_TITLE}" \
		--admin_user="${WP_ADMIN_LOGIN}" \
		--admin_password="$(cat /run/secrets/wp_admin_password)" \
		--admin_email="${WP_ADMIN_EMAIL}"

	echo "Creating WordPress user..."
	wp user create \
		--allow-root \
		"${WP_USER_LOGIN}" "${WP_USER_EMAIL}" \
		--user_pass="$(cat /run/secrets/wp_user_password)" \
		--role="author"

	echo "WordPress installation complete."
fi

echo "Starting PHP-FPM Engine..."
# Launch PHP-FPM in the foreground with the `-F` flag.
exec $(find /usr/sbin -name "php-fpm*" | head -n 1) -F
