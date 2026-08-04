# Base OS
FROM alpine:3.23

# Copy the configuration file to the folder where NGINX expects it
# (e.g., COPY <source> <destination>)
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Install NGINX and OpenSSL
RUN apk add --no-cache \
	nginx \
    openssl

# Create Self-Signed Certificate with OpenSSL
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
    -out /etc/nginx/ssl/juljin.crt \
    -keyout /etc/nginx/ssl/juljin.key \
    -subj "/CN=juljin.42.fr"

# Make NGINX stay in the foreground, making it PID 1
CMD ["nginx", "-g", "daemon off;"]
