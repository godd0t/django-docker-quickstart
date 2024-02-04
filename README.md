# Django Docker Quickstart

This quickstart provides an easy way to initiate a Django project using Docker. It comes with pre-configured services including PostgreSQL, Redis, Celery (worker and beat), Nginx, and Traefik, ready to run a Django web application. Additionally, it provides a few handy shortcuts for easier development.

---

## Features 🚀

- **Django** web application framework
- **PostgreSQL** database
- **Redis** in-memory data structure store
- **Celery** worker and beat services for running background tasks asynchronously
- **Nginx** web server for serving static and media files, and proxying requests to the Django application
- **Traefik** reverse proxy for routing requests to the appropriate service and providing SSL termination

## Included Packages and Tools 🛠️

- **Pytest**: Testing framework
- **Pytest Sugar**: A pytest plugin for a better look
- **Pytest Django**: A pytest plugin providing useful tools for testing Django applications
- **Coverage**: Test coverage tool
- **Ruff**: Linter
- **Black**: Code formatter

## Requirements 📋

- Docker & Docker Compose - [Install and Use Docker](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04)
- Python 3.10 or higher
- Make (optional for shortcuts)

---

## Getting Started 🏁

1. **Clone the repository:**
    ```bash
    git clone https://github.com/godd0t/django-docker-quickstart.git
    ```

2. **Change directory into the project:**
    ```bash
    cd django-docker-quickstart
    ```

3. **Copy the `env.example` file to `.env` and update the values as needed:**  

   - **For Linux/macOS:**  
     ```bash
     cp env.example .env
     ```
   - **For Windows (Command Prompt):**  
     ```cmd
      Copy-Item -Path env.example -Destination .env
     ```

---

## Initial Setup ⚙️

### Development Prerequisites

1. **Create a virtual environment:**
    ```bash
    python -m venv venv
    ```

2. **Activate the virtual environment:**
    ```bash
    source venv/bin/activate
    ```

3. **(Optional) Install the development requirements specific to your IDE for enhanced functionality and support.**
    ```bash
    pip install -r src/requirements.dev.txt
    ```

4. **Build the image and run the container:**  
   
   - If buildkit is not enabled, enable it and build the image:
     ```bash
     DOCKER_BUILDKIT=1 COMPOSE_DOCKER_CLI_BUILD=1 docker-compose -f docker-compose.yml up --build -d
     ```
   
   - If buildkit is enabled, build the image:
     ```bash
     docker-compose -f docker-compose.yml up --build -d
     ```
   
   - Or, use the shortcut:
     ```bash
     make build-dev
     ```

You can now access the application at http://localhost:8000. The development environment allows for immediate reflection of code changes.

### Production Setup

1. **Build the image and run the container:**  

   - If buildkit is not enabled, enable it and build the image:
     ```bash
       DOCKER_BUILDKIT=1 COMPOSE_DOCKER_CLI_BUILD=1 docker-compose -f docker-compose.prod.yml up --build -d
     ```

   - If buildkit is enabled, build the image:
     ```bash
      docker-compose -f docker-compose.prod.yml up --build -d
     ```
   - Or, use the shortcut:
     ```bash
       make build-prod
     ```

---

## Shortcuts 🔑

This project includes several shortcuts to streamline the development process:

- **Create migrations:**
    ```bash
    make make-migrations
    ```

- **Run migrations:**
    ```bash
    make migrate
    ```

- **Run the linter:**
    ```bash
    make lint
    ```

- **Run the formatter:**
    ```bash
    make format
    ```

- **Run the tests:**
    ```bash
    make test
    ```

- **Create a super user:**
    ```bash
    make super-user
    ```

- **Build and run dev environment:**
    ```bash
    make build-dev
    ```

- **Build and run prod environment:**
    ```bash
    make build-prod
    ```
---
