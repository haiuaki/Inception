# Base OS
FROM alpine:3.23

# Install wget (to download the binary) and gcompat (which cAdvisor requires to run on Alpine)
RUN apk add --no-cache wget gcompat

# Download the pre-compiled cAdvisor binary directly from Google's GitHub releases
RUN wget -qO /usr/local/bin/cadvisor https://github.com/google/cadvisor/releases/download/v0.49.1/cadvisor-v0.49.1-linux-amd64

# Give the binary execution permissions
RUN chmod +x /usr/local/bin/cadvisor

# Expose the default cAdvisor port
EXPOSE 8080

# Launch cAdvisor
CMD ["/usr/local/bin/cadvisor"]
