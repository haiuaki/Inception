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
all:
	@printf "$(CYAN)► Building and launching the LEMP stack...$(RESET)\n"
	@docker compose -f ${COMPOSE} up -d --build

# Stop the containers safely
down:
	@printf "$(YELLOW)► Stopping the LEMP stack...$(RESET)\n"
	@docker compose -f ${COMPOSE} down

# --- ISOLATED DEBUGGING RULES ---------------------------------------------- //

# Test NGINX in the foreground (no -d flag)
nginx-test:
	@printf "$(CYAN)► Building and launching NGINX only (ignoring dependencies)...$(RESET)\n"
	@docker compose -f ${COMPOSE} --env-file ${ENV_FILE} up --build --no-deps nginx

# Jump in the NGINX container
nginx-shell:
	@printf "$(MAGENTA)► Opening interactive shell inside NGINX container...$(RESET)\n"
	@docker exec -it nginx sh

# --- UTILITIES ------------------------------------------------------------- //

re: fclean all

fclean:
	@printf "$(RED)► Total clean of all Docker configurations...$(RESET)\n"
	@# Stops and removes containers, images and network created by the .yml file
	@docker compose -f ${COMPOSE} down --rmi all -v
	@printf "$(GREEN)✓ Clean complete.$(RESET)\n"

.PHONY: all down re fclean \
        nginx-test nginx-shell
