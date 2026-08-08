# Base OS
FROM alpine:3.23

# Install the Very Secure FTP Daemon
RUN apk add --no-cache vsftpd

# Copy configuration and setup scripts
COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY tools/main.sh /usr/local/bin/

# Make the script executable
RUN chmod +x /usr/local/bin/main.sh

# Expose Port 21 (Command) and Ports 21100-21110 (Passive Mode Data Transfer)
EXPOSE 21 21100-21110

ENTRYPOINT ["/usr/local/bin/main.sh"]
