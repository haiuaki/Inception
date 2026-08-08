#!/bin/sh

# Check if the FTP user already exists
if ! id -u "${FTP_USER}" > /dev/null 2>&1; then
	echo "Creating FTP user..."
	
	# Read the password from Docker secrets
	FTP_PWD=$(cat /run/secrets/ftp_password)

	# Create the user, set their home directory to the WordPress volume, and set their password
	adduser -D -h /var/www/html "${FTP_USER}"
	echo "${FTP_USER}:${FTP_PWD}" | chpasswd

	# Add them to the vsftpd allowed userlist
	echo "${FTP_USER}" > /etc/vsftpd.userlist
fi

# Ensure the WordPress directory has the correct permissions so the FTP user can upload
chown -R ${FTP_USER}:${FTP_USER} /var/www/html

echo "Starting vsftpd..."
exec vsftpd /etc/vsftpd/vsftpd.conf
