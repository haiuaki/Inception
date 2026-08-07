# Base OS
FROM alpine:3.23

# Install Python3 to use its built-in HTTP server
RUN apk add --no-cache python3

# Copy the HTML/CSS/JS files into the container
COPY html /var/www/static_site

# Set the working directory to where the files are
WORKDIR /var/www/static_site

# Expose port 8081 for the internal network
EXPOSE 8081

# Run the Python3 built-in HTTP server
CMD ["python3", "-m", "http.server", "8081"]
