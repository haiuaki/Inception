# User Documentation

## 1. Provided Services
This project provides a complete web infrastructure (LEMP Stack) packaged into Docker containers. It consists of:
- **NGINX**: A secure web server that handles incoming HTTPS traffic.
- **MariaDB**: The relational database engine completely isolated from the host, storing website data.
- **WordPress**: The PHP-FPM application server and Content Management System used to build the website.

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
- **Administration Panel:** `https://juljin.42.fr/wp-login.php`

## 4. Credentials Management
All non-sensitive configuration (like the Database Name and Username) is stored in the `srcs/.env` file. 
All highly sensitive passwords are kept out of the environment entirely using Docker Secrets. To view or modify passwords, edit the raw text files located inside the `secrets/` directory on the Host Machine.

> [!WARNING]
> **Changing Credentials After Launch**  
> If you start the project and later decide to change passwords in the `secrets/` folder or usernames in the `.env` file, simply running `make down` and `make` will **NOT** apply the changes! 
> Because database configurations are permanently saved to the Host Volumes on the first boot, you must run `make fclean` to wipe the old data volumes before launching the stack again.

## 5. Checking Service Health
If you need to verify that all servers are running correctly, you can check their live status using Docker.

- **View running services:**
  ```bash
  docker ps
  ```
- **View live server logs (to spot errors):**
  ```bash
  make logs
  ```

## 6. Bonus Features
This infrastructure includes several extra-credit bonus features that run securely alongside the main WordPress stack:

- **Static Website (Digital Clock):** `https://juljin.42.fr/clock/`
  A vanilla HTML/CSS/JS digital clock served directly by NGINX.
- **Adminer (Database GUI):** `https://juljin.42.fr/adminer/`
  A lightweight graphical interface to manage the MariaDB database. Log in using the `wp_user` credentials located in your `.env` and `secrets/db_password.txt` files.
