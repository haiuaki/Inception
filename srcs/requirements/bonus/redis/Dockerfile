# Base OS
FROM alpine:3.23

# Install the pre-compiled Redis package
RUN apk add --no-cache redis

# Expose the standard Redis port
EXPOSE 6379

# Launch Redis, bind it to all network interfaces,
# and disable protected mode (becquse our Docker network is private)
CMD ["redis-server", "--bind", "0.0.0.0", "--protected-mode", "no"]
