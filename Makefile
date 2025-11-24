.PHONY: help build up down clean analyze test integration all logs

DOCKER_COMPOSE := docker compose -f docker/docker-compose.yml -p simplenotes

help: ## Показать это сообщение помощи
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Собрать все Docker образы
	$(DOCKER_COMPOSE) build

up: ## Запустить все контейнеры
	$(DOCKER_COMPOSE) up

down: ## Остановить все контейнеры
	$(DOCKER_COMPOSE) down

clean: ## Очистить все контейнеры и volumes
	$(DOCKER_COMPOSE) down -v
	docker system prune -f

analyze: ## Запустить только анализатор кода
	$(DOCKER_COMPOSE) run --rm analyzer

test: ## Запустить только unit-тесты
	$(DOCKER_COMPOSE) run --rm test

builder: ## Запустить только сборку APK
	$(DOCKER_COMPOSE) run --rm builder

integration: ## Запустить только integration-тесты
	$(DOCKER_COMPOSE) run --rm integration

all: ## Запустить весь CI/CD пайплайн последовательно
	@make analyze
	@make test
	@make builder
	@make integration

logs: ## Показать логи контейнеров
	$(DOCKER_COMPOSE) logs -f

parallel: ## Запустить analyzer и test параллельно
	$(DOCKER_COMPOSE) up analyzer test

extract-apk: ## Скопировать собранный APK из volume
	@docker run --rm -v flutter-build-output:/build alpine cat /build/app/outputs/flutter-apk/app-prod-release.apk > app-release.apk
	@echo "APK extracted to ./app-release.apk"

extract-coverage: ## Скопировать coverage из volume
	@docker run --rm -v flutter-test-coverage:/cov alpine tar -czf - -C /cov . | tar -xzf - -C ./coverage
	@echo "Coverage extracted to ./coverage/"
