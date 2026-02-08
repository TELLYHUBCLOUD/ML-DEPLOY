FROM python:3.10-slim-bullseye

# Set environment variables
ENV PIP_NO_CACHE_DIR=1 \
    PYTHONUNBUFFERED=1 \
    DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    wget \
    ffmpeg \
    aria2 \
    qbittorrent-nox \
    sox \
    mediainfo \
    p7zip-full \
    unzip \
    libmagic1 \
    gnupg2 \
    build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Rclone
RUN curl https://rclone.org/install.sh | bash

# Set up working directory
WORKDIR /usr/src/app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy source code
COPY . .

# Set permissions
RUN chmod +x start.sh

# Entrypoint
CMD ["bash", "start.sh"]
