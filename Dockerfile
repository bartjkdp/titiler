# Dockerfile for TiTiler application with custom EPSG:28992 TMS
FROM python:3.13-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update && apt-get install -y \
    build-essential \
    gdal-bin \
    libgdal-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install titiler.application and uvicorn
RUN pip install --upgrade pip \
    && pip install titiler.application \
    && pip install uvicorn

# Copy application code
COPY titiler/ ./titiler/

EXPOSE 8000

CMD ["uvicorn", "titiler.application.main:app", "--host", "0.0.0.0", "--port", "8000"]
