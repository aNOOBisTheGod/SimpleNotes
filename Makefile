.PHONY: help build up down clean analyze test integration all logs

help: ## Показать это сообщение помощи
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## Собрать все Docker образы
	cd docker && docker-compose build

up: ## Запустить все контейнеры
	cd docker && docker-compose up

down: ## Остановить все контейнеры
	cd docker && docker-compose down

clean: ## Очистить все контейнеры и volumes
	cd docker && docker-compose down -v
	docker system prune -f

analyze: ## Запустить только анализатор кода
	cd docker && docker-compose run --rm analyzer

test: ## Запустить только unit-тесты
	cd docker && docker-compose run --rm test

builder: ## Запустить только сборку APK
	cd docker && docker-compose run --rm builder

integration: ## Запустить только integration-тесты
	cd docker && docker-compose run --rm integration

all: ## Запустить весь CI/CD пайплайн последовательно
	@make analyze
	@make test
	@make builder
	@make integration

logs: ## Показать логи контейнеров
	cd docker && docker-compose logs -f

parallel: ## Запустить analyzer и test параллельно
	cd docker && docker-compose up analyzer test

extract-apk: ## Скопировать собранный APK из volume
	@docker run --rm -v flutter-build-output:/build alpine cat /build/app/outputs/flutter-apk/app-prod-release.apk > app-release.apk
	@echo "APK extracted to ./app-release.apk"

extract-coverage: ## Скопировать coverage из volume
	@docker run --rm -v flutter-test-coverage:/cov alpine tar -czf - -C /cov . | tar -xzf - -C ./coverage
	@echo "Coverage extracted to ./coverage/"
