# --- COLORS ---------------------------------------------------------------- //

RESET   = \033[0m
GRAY    = \033[90m
RED     = \033[31m
GREEN   = \033[32m
YELLOW  = \033[33m
BLUE    = \033[34m
MAGENTA = \033[35m
CYAN    = \033[36m

# --- VARIABLES ------------------------------------------------------------- //

COMPOSE  = ./srcs/docker-compose.yml
ENV_FILE = ./srcs/.env

# --- PRODUCTION RULES ------------------------------------------------------ //

# Default target: Builds and launches the LEMP stack
all: setup_dirs
	@printf "$(CYAN)► Building and launching the LEMP stack...$(RESET)\n"
	@docker compose -f ${COMPOSE} --env-file ${ENV_FILE} up -d --build

# Create host data directories if they don't exist
setup_dirs:
	@printf "$(CYAN)► Creating host data directories...$(RESET)\n"
	@mkdir -p ~/data/mariadb ~/data/wordpress

# Stop the containers safely
down:
	@printf "$(YELLOW)► Stopping the LEMP stack...$(RESET)\n"
	@docker compose -f ${COMPOSE} --env-file ${ENV_FILE} down

# --- DEBUGGING & INTERACTION RULES ------------------------------------------- //

# Test NGINX in the foreground (no -d flag)
nginx-test:
	@printf "$(CYAN)► Building and launching NGINX only (ignoring dependencies)...$(RESET)\n"
	@docker compose -f ${COMPOSE} --env-file ${ENV_FILE} up --build --no-deps nginx

# Jump in the NGINX container
nginx-shell:
	@printf "$(MAGENTA)► Opening interactive shell inside NGINX container...$(RESET)\n"
	@docker exec -it nginx sh

# Test MariaDB in the foreground (no -d flag)
mariadb-test:
	@printf "$(CYAN)► Building and launching MariaDB only (ignoring dependencies)...$(RESET)\n"
	@docker compose -f ${COMPOSE} --env-file ${ENV_FILE} up --build --no-deps mariadb

# Run the SQL queries to print the databases and the users
mariadb-run:
	@printf "$(CYAN)► Testing MariaDB connection and databases...$(RESET)\n"
	@docker exec -it mariadb mariadb -u root -p -e "SHOW DATABASES; SELECT User, Host FROM mysql.user;"

# Jump in the MariaDB container
mariadb-shell:
	@printf "$(YELLOW)► Opening interactive shell inside MariaDB container...$(RESET)\n"
	@docker exec -it mariadb sh

# Test WordPress in the foreground (no -d flag)
wordpress-test: setup_dirs
	@printf "$(CYAN)► Building and launching WordPress only (ignoring dependencies)...$(RESET)\n"
	@docker compose -f ${COMPOSE} --env-file ${ENV_FILE} up --build --no-deps wordpress

# Jump in the WordPress container
wordpress-shell:
	@printf "$(MAGENTA)► Opening interactive shell inside WordPress container...$(RESET)\n"
	@docker exec -it wordpress sh

# --- LOGGING RULES --------------------------------------------------------- //

# View all live logs
logs:
	@docker compose -f ${COMPOSE} --env-file ${ENV_FILE} logs -f

# View live NGINX logs
nginx-logs:
	@docker compose -f ${COMPOSE} --env-file ${ENV_FILE} logs -f nginx

# View live MariaDB logs
mariadb-logs:
	@docker compose -f ${COMPOSE} --env-file ${ENV_FILE} logs -f mariadb

# View live WordPress logs
wordpress-logs:
	@docker compose -f ${COMPOSE} --env-file ${ENV_FILE} logs -f wordpress

# --- UTILITIES ------------------------------------------------------------- //

re: fclean all

fclean:
	@printf "$(RED)► Total clean of all Docker configurations...$(RESET)\n"
	@# Stops and removes containers, images and network created by the .yml file
	@docker compose -f ${COMPOSE} down --rmi all -v
	@printf "$(RED)► Deleting persistent data folders...$(RESET)\n"
	@sudo rm -rf ~/data/mariadb ~/data/wordpress
	@printf "$(GREEN)✓ Clean complete.$(RESET)\n"

.PHONY: all down re fclean \
        nginx-test nginx-shell nginx-logs \
		mariadb-run mariadb-test mariadb-shell mariadb-logs \
		wordpress-test wordpress-shell wordpress-logs \
		setup_dirs logs
