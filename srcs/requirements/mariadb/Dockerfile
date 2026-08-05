# Base OS
FROM alpine:3.23

# Copy the main shell script to image
COPY tools/main.sh /usr/local/bin/main.sh

# Add execution permissions to the main shell script
RUN chmod +x /usr/local/bin/main.sh

# Install MariaDB
RUN apk add --no-cache \
	mariadb \
	mariadb-client
	
# Create the socket directory for MariaDB and grant ownership to the `mysql` user
RUN mkdir -p /run/mysqld && \
	chown -R \
	mysql:mysql \
	/run/mysqld

# 1. Turn the TCP/IP network for the database, allowing connections from other containers
# 2. MariaDB is configured to `localhost`, since WordPress will have its own container,
#    it has a different IP address. Accept any incoming connections from any IP address on
#    the internal Docker Network.
RUN sed -i "s|skip-networking|skip-networking=0|g" /etc/my.cnf.d/mariadb-server.cnf && \
    sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

# Custom setup script to configure and launch MariaDB when the container boots
ENTRYPOINT ["main.sh"]
