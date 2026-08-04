# Developer Documentation

## 1. Environment Setup

### Prerequisites
This project requires `sudo` privileges as well as `make`, `docker`, and `docker compose` to be installed.
On a fresh Debian/Ubuntu Virtual Machine, install them via:
```bash
sudo apt update && sudo apt install docker.io docker-compose make -y
```

### Host File Configuration
The NGINX entrypoint is strictly configured to the domain name `juljin.42.fr` over HTTPS.
To access the site locally, you must map the loopback address to this domain using `sudo`:
```bash
sudo nano /etc/hosts
```
And append the following line:
```txt
127.0.0.1 juljin.42.fr
```

### Configuration & Secrets
- **Infrastructure Configuration**: The core services and networks are managed via the `srcs/docker-compose.yml` file.
- **NGINX Configuration**: The specific server routing and SSL rules are located in `srcs/requirements/nginx/conf/nginx.conf`.
- **Secrets**: *(To be implemented when MariaDB is added. Currently, no sensitive passwords are required for the standalone NGINX container.)*

## 2. Build and Launch
The entire project is managed via a single `Makefile` located at the root of the repository.

To build the images and launch the infrastructure using Make:
```bash
make
```

*(Alternative)* To launch the infrastructure directly via Docker Compose without the Makefile:
```bash
docker compose -f srcs/docker-compose.yml up -d --build
```

To test NGINX in isolation (without launching future dependencies):
```bash
make nginx-test
```

## 3. Container Management Commands
You can manage the state of the containers using the following `Makefile` targets:

| Command | Description |
| --- | --- |
| `make down` | Gracefully stops the containers and removes the default network. |
| `make fclean` | Force-removes all containers, networks, volumes, and cached images. |
| `make nginx-shell` | Opens an interactive `sh` shell inside the running NGINX container. |

## 4. Data Persistence

*(Note: Currently, the NGINX container does not generate or store any dynamic persistent data. This section will be updated to document the local Host paths for the MariaDB and WordPress Docker Volumes once they are implemented.)*
