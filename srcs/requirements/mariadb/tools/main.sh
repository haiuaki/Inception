#!/bin/sh

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Initializing MariaDB.."

	# Initialize MariaDB database with `mariadb-install-db`
	# Hidden user `mysql` created by Alpine Linux
	mariadb-install-db \
		--user=mysql \
		--datadir=/var/lib/mysql \
		> /dev/null # Send logs to the black hole

	# Retrieve non-sensitive variables from `.env`
	NAME=${DB_NAME}
	USER=${DB_USER}

	# Read the passwords from the Docker Secrets files
	PASSWD=$(cat /run/secrets/db_password)
	ROOT_PASSWD=$(cat /run/secrets/db_root_password)

	# Create a temporary SQL file
	cat << EOF > /tmp/init.sql
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS $NAME;
CREATE USER IF NOT EXISTS '$USER'@'%' IDENTIFIED BY '$PASSWD';
GRANT ALL PRIVILEGES ON $NAME.* TO '$USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED by '$ROOT_PASSWD';
FLUSH PRIVILEGES;
EOF

	# Feed the file into MariaDB's bootstrap engine
	mariadbd \
		--user=mysql \
		--bootstrap < /tmp/init.sql

	rm -f /tmp/init.sql
	echo "MariaDB is initialized."
fi

echo "Starting MariaDB daemon.."
exec mariadbd \
	--user=mysql \
	--datadir=/var/lib/mysql
