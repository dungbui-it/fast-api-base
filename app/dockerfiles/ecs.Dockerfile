FROM python:3.12-slim

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV EXECUTION_ENVIRONMENT=ecs

# Copy app
COPY app /api

WORKDIR /api

RUN uv venv && \
    uv sync --frozen --no-cache

# Expose port
EXPOSE 80


CMD [".venv/bin/uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80"]
