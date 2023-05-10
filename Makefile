PROJECTNAME := project_name
SHELL := /bin/sh
APP_NAME := project_name
BACKEND_APP_NAME := $(APP_NAME)-backend

define HELP

Manage $(PROJECTNAME). Usage:

make lint           	Run linter
make format         	Run formatter
make test           	Run tests
make super-user     	Create super user
make make-migrations 	Make migrations
make migrate        	Migrate
make build-dev      	Build and run dev environment
make stop-dev       	Stop dev environment
make stop-prod      	Stop prod environment
make build-prod     	Build and run prod environment
make all            	Show help

endef

export HELP

help:
	@echo "$$HELP"

lint:
	 @bash ./scripts/lint.sh

format:
	@bash ./scripts/format.sh

test:
	@bash ./scripts/test.sh

super-user:
	docker exec -it $(BACKEND_APP_NAME) sh "-c" \
	"python manage.py createsuperuser"

make-migrations:
	docker exec -it $(BACKEND_APP_NAME) $(SHELL) "-c" \
	"python manage.py makemigrations"

migrate:
	docker exec -it $(BACKEND_APP_NAME) $(SHELL) "-c" \
	"python manage.py migrate"

build-dev:
	docker-compose -f docker-compose.yml up --build -d

build-prod:
	docker-compose -f docker-compose.prod.yml up --build -d

stop-dev:
	@docker-compose -f docker-compose.yml down

stop-prod:
	@docker-compose -f docker-compose.prod.yml down

all: help

.PHONY: help lint format test super-user make-migrations migrate build-dev build-prod stop-dev stop-prod all
