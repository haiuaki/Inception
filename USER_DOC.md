# User Documentation

## 1. Provided Services
This project provides a complete web infrastructure (LEMP Stack) packaged into Docker containers. It consists of:
- **NGINX**: A secure web server that handles incoming HTTPS traffic.
- **MariaDB**: The relational database engine completely isolated from the host, storing website data.
- **WordPress**: *(Coming Soon)* The Content Management System used to build and manage the website.

## 2. Starting and Stopping the Project
The entire project is controlled using simple commands from the root directory.

- **To start the project in the background:**
  ```bash
  make
  ```
- **To safely stop the project:**
  ```bash
  make down
  ```

## 3. Accessing the Website
Once the project is started, you can access the website securely via your web browser. 
*(Note: You must accept the security warning for the self-signed certificate on your first visit).*

- **Public Website:** `https://juljin.42.fr`
- **Administration Panel:** *(Coming Soon: `https://juljin.42.fr/wp-admin`)*

## 4. Credentials Management
All non-sensitive configuration (like the Database Name and Username) is stored in the `srcs/.env` file. 
All highly sensitive passwords are kept out of the environment entirely using Docker Secrets. To view or modify passwords, edit the raw text files located inside the `secrets/` directory on the Host Machine.
## 5. Checking Service Health
If you need to verify that all servers are running correctly, you can check their live status using Docker.

- **View running services:**
  ```bash
  docker ps
  ```
- **View live server logs (to spot errors):**
  ```bash
  docker compose -f srcs/docker-compose.yml logs -f
  ```
