# Developer Documentation

## 1. Environment Setup

### Prerequisites
This project requires `sudo` privileges as well as `make`, `docker`, and `docker compose` to be installed.
On a fresh Debian/Ubuntu Virtual Machine, install them via:
```bash
sudo apt update && sudo apt install docker.io docker-compose make -y
```

### Docker Permissions (Post-Installation)
To avoid having to type `sudo` before every Docker command, you must add your current user to the `docker` group:
```bash
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
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
Because this repository contains sensitive configuration, the `srcs/.env` file and `secrets/` directory are deliberately excluded via `.gitignore`. **Before running the project for the first time**, you must manually recreate them at the root of the project.

**1. The `.env` file (located at `srcs/.env`):**
```env
# Host machine user for local volume mounting
USER_LOGIN=your_login

# Static domain name required for NGINX TLS routing
DOMAIN_NAME=juljin.42.fr

# Database configuration
DB_NAME=wordpress
DB_USER=wp_user

# WordPress configuration
WP_TITLE=INCEPTION

WP_ADMIN_LOGIN=juljin
WP_ADMIN_EMAIL=juljin@42.fr

WP_USER_LOGIN=johndoe
WP_USER_EMAIL=johndoe@42.fr
```

**2. The Secrets (located at the root):**
You must create a `secrets/` directory containing raw text files with your chosen passwords. These are securely mounted directly into the containers at runtime, keeping them entirely out of the environment variables.

*For MariaDB:*
- `secrets/db_password.txt`: (e.g., `wp_secure_pass`)
- `secrets/db_root_password.txt`: (e.g., `root_secure_pass`)

*For WordPress:*
- `secrets/wp_admin_password.txt`: (e.g., `admin_secure_pass`)
- `secrets/wp_user_password.txt`: (e.g., `user_secure_pass`)

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

To test MariaDB in isolation (without launching future dependencies):
```bash
make mariadb-test
```

To test WordPress in isolation (forces a MariaDB connection wait loop):
```bash
make wordpress-test
```

## 3. Container Management Commands
You can manage the state of the containers using the following `Makefile` targets:

| Command | Description |
| --- | --- |
| `make down` | Gracefully stops the containers and removes the default network. |
| `make fclean` | Force-removes all containers, networks, volumes, and cached images. |
| `make nginx-shell` | Opens an interactive `sh` shell inside the running NGINX container. |
| `make mariadb-run` | Securely queries the internal MariaDB database to verify WordPress user creation. |
| `make mariadb-shell` | Opens an interactive `sh` shell inside the running MariaDB container. |
| `make logs` | Streams the live logs for all running containers simultaneously. |
| `make nginx-logs` | Streams only the live logs for the NGINX container. |
| `make mariadb-logs` | Streams only the live logs for the MariaDB container. |
| `make wordpress-logs` | Streams only the live logs for the WordPress container. |
## 4. Data Persistence

To ensure data survives container destruction, internal container paths are mapped to physical directories on the Host machine using Docker Volumes.

| Service | Internal Container Path | Host Machine Path |
| --- | --- | --- |
| **MariaDB** | `/var/lib/mysql` | `/home/${USER_LOGIN}/data/mariadb` |
| **WordPress** | `/var/www/html` | `/home/${USER_LOGIN}/data/wordpress` |
