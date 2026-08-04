_This project has been created as part of the 42 curriculum by juljin._

# Inception

## Description

`Inception` is a System Administration project designed to broaden your knowledge of network deployment and virtualization. It requires the creation of a complete **LEMP Stack** (Linux, NGINX, MariaDB, PHP/WordPress) entirely from scratch using Docker containers. The infrastructure is orchestrated via Docker Compose and operates on an isolated internal network, with only the NGINX reverse proxy exposed securely over HTTPS.

## Instructions

For detailed setup, debugging, and configuration instructions, please refer to the dedicated documentation:
- [Developer Documentation](DEV_DOC.md)
- [User Documentation](USER_DOC.md)

### Commands

The entire infrastructure is managed via the `Makefile` located at the root of the repository.

| Command | Description |
| --- | --- |
| `make` | Builds all Docker images and launches the complete infrastructure in detached mode. |
| `make down` | Gracefully stops the containers and removes the default bridge network. |
| `make nginx-test` | Builds and launches only the NGINX container in the foreground for debugging. |
| `make nginx-shell`| Opens an interactive `sh` shell inside the running NGINX container. |
| `make fclean` | A nuclear cleanup. Force-removes all containers, networks, volumes, and cached images. |
| `make re` | Performs an `fclean` followed by `make`. |

## Technical Overview

### Why Docker Instead of VMs?

Previously, hosting a web server, a database, and an application required either cramming everything onto a single operating system (which is insecure and messy) or spinning up three separate Virtual Machines (which consumes massive amounts of RAM and CPU). 
This project leverages **Docker** to solve both problems. By containerizing NGINX, MariaDB, and WordPress, each service runs in its own highly secured, isolated bubble. Because containers share the host's Linux kernel instead of booting their own OS, the entire infrastructure runs with almost zero performance overhead.

### Docker Network vs Host Network

When deploying containers, Docker offers multiple networking modes. 
If a container is run on the **Host Network**, it completely bypasses Docker's network isolation. It shares the exact same IP address and open ports as the host machine, which can lead to port conflicts and severe security vulnerabilities (as databases would be directly exposed to the internet).
Instead, this project utilizes a custom **Docker Bridge Network**. This creates a heavily isolated virtual sub-network inside the host. The MariaDB and WordPress containers live entirely inside this bubble and cannot be accessed from the outside. Only the NGINX container is given a specific port mapping (`443:443`) to act as a bridge between the host machine and the isolated network, ensuring all incoming traffic is strictly filtered and encrypted before reaching the backend.

### Infrastructure Breakdown

- **Minimalist Base (Images):** To keep the attack surface and file sizes as small as possible, every service is built manually from `alpine:3.23` rather than relying on bloated pre-configured images.
- **Data Persistence (Volumes):** Containers are designed to be destroyed and recreated instantly. Because this destroys all internal files, we use Docker Volumes to securely map the MariaDB database and WordPress core files directly to physical folders on the host machine (`/home/login/data/`).

## Resources

### 1. References
- [Docker Hub: NGINX](https://hub.docker.com/_/nginx) - Official Docker image documentation for NGINX.
- [OpenSSL req Documentation](https://docs.openssl.org/master/man1/openssl-req/) - Manual for generating self-signed certificates.
- [Transport Layer Security (TLS)](https://en.wikipedia.org/wiki/Transport_Layer_Security) - Overview of the TLS cryptographic protocol.

### 2. Use of AI

AI was utilized as a technical assistant during the development of this project:
- **Tasks**: Used for generating boilerplate documentation and understanding complex Docker concepts (container vs host networking, orchestration, and security best practices).
- **Parts**: The structural formatting of the `README.md`, `USER_DOC.md`, and `DEV_DOC.md`.

_Note: All underlying infrastructure, Makefiles, and configuration files were manually implemented and fully understood by the author to ensure technical integrity._
