# Django Docker Quickstart

This is a quickstart for Django with Docker.

## Features

- Django
- PostgreSQL
- Redis
- Celery(worker and beat)
- Nginx
- Traefik

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

### Development

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
   
4. Build and run the project:
    ```
   docker-compose up --build -d
    ```


### Production

To set up the project for production, follow these steps:

1. Build the image and run the container:
    ```
    docker-compose -f docker-compose.prod.yml up --build -d
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
