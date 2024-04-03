FROM python:3.11-slim-bullseye

# Build Args
ARG PROJECT_VERSION

RUN echo "version = ${PROJECT_VERSION}"

# Set environment variables
ENV WORKSPACE_ROOT=/opt/quickstart/ \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    POETRY_HOME="/opt/poetry" \
    POETRY_NO_INTERACTION=1

RUN mkdir -p $WORKSPACE_ROOT

# Install OS dependencies
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends build-essential \
    gcc \
    curl \
    libgnutls28-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libpq-dev \
    && apt-get clean

# Install Poetry - respects $POETRY_VERSION & $POETRY_HOME
RUN curl -sSL https://install.python-poetry.org | python -
ENV PATH="$POETRY_HOME/bin:$PATH"

RUN apt-get remove -y curl

COPY poetry.lock pyproject.toml ./

# Install Python dependencies
RUN poetry config virtualenvs.create false
RUN poetry install \
    && rm poetry.lock pyproject.toml \
    && useradd -U vonq \
    && install -d -m 0755 -o vonq -g vonq ${WORKSPACE_ROOT}

WORKDIR $WORKSPACE_ROOT

USER vonq:vonq

COPY --chown=vonq:vonq . .
RUN chmod a+x ./scripts/entrypoint.sh

CMD ["./scripts/entrypoint.sh"]
