# User Documentation

## 1. Provided Services
This project provides a complete web infrastructure (LEMP Stack) packaged into Docker containers. It consists of:
- **NGINX**: A secure web server that handles incoming HTTPS traffic.
- **MariaDB**: *(Coming Soon)* The database engine used to store website data.
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
*(Coming Soon: This section will explain where to find the `.env` file and Docker Secrets to securely view or modify the passwords for the WordPress Administrator and Database users.)*

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
