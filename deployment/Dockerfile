FROM python:3.11-slim
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /usr/src/app

RUN --mount=type=cache,target=/var/cache/apt \
	apt-get update && \
    apt-get install --no-install-recommends -y build-essential libpq-dev \
    && rm -rf /var/lib/apt/lists/*


COPY src/requirements.txt ./requirements.txt

RUN --mount=type=cache,target=/root/.cache/pip \
    pip install pip --upgrade \
    && pip install -r requirements.txt


COPY deployment/scripts /app/deployment/scripts

RUN chmod -R +x /app/deployment/scripts/*

COPY src/ ./
