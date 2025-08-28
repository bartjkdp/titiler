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

ENV CPL_VSIL_CURL_ALLOWED_EXTENSIONS=".tif,.TIF,.tiff"
ENV GDAL_HTTP_MULTIPLEX=YES
ENV GDAL_HTTP_VERSION=2
ENV GDAL_HTTP_MERGE_CONSECUTIVE_RANGES=YES
ENV GDAL_DISABLE_READDIR_ON_OPEN=EMPTY_DIR
ENV GDAL_CACHEMAX=200
ENV CPL_VSIL_CURL_CACHE_SIZE=200000000
ENV VSI_CACHE=TRUE
ENV VSI_CACHE_SIZE=5000000
ENV PROJ_NETWORK=ON
ENV GDAL_HTTP_MULTIPLEX=YES

EXPOSE 8000

CMD ["uvicorn", "titiler.application.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4", "--proxy-headers"]
