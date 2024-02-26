.DEFAULT_GOAL      = help
SHELL              = bash
DOCKER_COMPOSE_BIN ?= docker-compose
DOCKER_COMPOSE     = DOCKER_UID=$(shell id -u) $(DOCKER_COMPOSE_BIN)
EXEC               = $(DOCKER_COMPOSE) exec
RUN                = $(DOCKER_COMPOSE) run
APP_ENV            ?= dev

help:
	@grep -E '(^[a-zA-Z0-9_\/-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

##
##
## —— 🐳 Docker️ ————————————————————————————————————————————————————————————
##
build: ## Build all necessary images
	$(DOCKER_COMPOSE) build
start: .env docker-compose.yaml build ## Up the stack
	$(DOCKER_COMPOSE) up -d
	@printf "You now can browse on \033[32mhttp://www.okofony.test:8080\033[0m\n"
stop: ## stop all or some containers of the project
	$(DOCKER_COMPOSE) stop $(filter-out $@,$(MAKECMDGOALS))

##
## —— Execute command ————————————————————————————————————————————————————————————
##
shell: ## Dive into the given container name
	$(EXEC) $(filter-out $@,$(MAKECMDGOALS)) sh
bin-console: ## execute console command
	$(EXEC) php php -d memory_limit=512M bin/console $(filter-out $@,$(MAKECMDGOALS))

##
## —— 🐬 Database️ ————————————————————————————————————————————————————————————
##
migration: ## Generate a doctrine migration based on the entities mapping
	$(EXEC) php bin/console doctrine:migrations:diff
migration-revert: ## Execute one migration by version  => `migration-revert 20201006134839`
	$(EXEC) php bin/console doctrine:migrations:migrate $(filter-out $@,$(MAKECMDGOALS))
migrate: ## Execute migrations  => `make migrate path/to/migration.php --dry-run`
	$(EXEC) php bin/console --env=$(APP_ENV) doctrine:migrations:sync-metadata-storage $(filter-out $@,$(MAKECMDGOALS))
	$(EXEC) php bin/console --env=$(APP_ENV) doctrine:migrations:migrate $(filter-out $@,$(MAKECMDGOALS))

##
## —— 🧙‍♂ Composer️ ————————————————————————————————————————————————————————————
##
composer-install: ## Install vendors according to the current composer.lock file
	$(EXEC) php composer install $(filter-out $@,$(MAKECMDGOALS))

composer-update: ## Update vendors according to the composer.json file
	$(EXEC) php composer update --no-progress --profile --prefer-dist $(filter-out $@,$(MAKECMDGOALS))
