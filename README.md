# Django Docker Boilerplate

---
Provides a quick and easy way to get started with a Django project using Docker.
It comes with pre-configured services,
including PostgreSQL, Redis, Celery (worker and beat),
Nginx, and Traefik, that can be used to run a Django web application.
It also comes with a few shortcuts to make development easier.
---

## Features

- Django web application framework
- PostgreSQL database
- Redis
- Celery worker and beat services: Celery is a task queue that is used to run background tasks asynchronously.
- Nginx web server: Used to serve static files and media files, and to proxy requests to the Django application.
- Traefik reverse proxy: Used to route requests to the appropriate service. It also provides SSL termination.

## Included Packages and Tools

- Pytest: Testing framework
- Pytest Sugar: Plugin for pytest that changes the default look
- Pytest Django: Plugin for pytest that provides useful tools for testing Django applications
- Coverage: Test coverage
- Ruff: Linter
- Black: Code formatter

## Requirements

- Docker
- Docker Compose
- Python 3.10 or higher
- Make(optional for shortcuts)


## Getting Started

To get started, follow these steps:

1. Clone the repository:
    
    ```
    git clone https://github.com/godd0t/django-docker-quickstart.git
    ```

2. Change directory into the project:
    ```
    cd django-docker-quickstart
    ```
   
3. Copy the `env.example` file to `.env` and update the values as needed:
    ```
    cp env.example .env
    ```

## Initial Setup

### Development Prerequisites

To set up the project for development, follow these steps:

1. Create a virtual environment:
    ```
    python -m venv venv
    ```
   
2. Activate the virtual environment:
    ```
    source venv/bin/activate
    ```
   
3. Install the development requirements:
    ```
    pip install -r requirements/requirements-dev.txt
    ```
4. Build the image and run the container:
    ```
    docker-compose -f docker-compose.dev.yml up --build -d
    ```
   Or you can use the shortcut:
    ```
    make build-dev
    ```
   
Now you can access the application at http://localhost:8000.
With the development environment, you can make changes to the code and the changes will be reflected immediately.


### Production

To set up the project for production, follow these steps:

1. Build the image and run the container:
    ```
    docker-compose -f docker-compose.prod.yml up --build -d
    ```
   Or you can use the shortcut:
    ```
    make build-prod
    ```


## Shortcuts

To make development easier, there are a few shortcuts available:

Create migrations:

```
make make-migrations
```

Run migrations:

```
make migrate
```

Run the linter:

```
make lint
```

Run the formatter:

```
make format
```

Run the tests:

```
make test
```

Create a super user:

```
make super-user
```

Build and run dev environment:

```
make build-dev
```

Build and run prod environment:

```
make build-prod
```
