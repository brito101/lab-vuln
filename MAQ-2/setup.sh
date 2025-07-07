#!/bin/bash

# Exit on error
set -e

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo "[+] Installing Docker..."
    sudo apt-get update
    sudo apt-get install -y docker.io
    sudo systemctl enable --now docker
fi

# Install Docker Compose if not present
if ! command -v docker-compose &> /dev/null; then
    echo "[+] Installing Docker Compose..."
    sudo apt-get install -y docker-compose
fi

# Go to the vulnerable app directory
cd "$(dirname "$0")/trainees"

# Ensure .env exists (exposed for vulnerability)
if [ ! -f .env ]; then
    echo "[!] .env file not found. Creating a vulnerable .env..."
    cp .env.example .env 2>/dev/null || touch .env
    echo "APP_DEBUG=true" >> .env
    echo "# WARNING: This .env is intentionally exposed for lab purposes!" >> .env
fi

# Set vulnerable permissions on storage
chmod -R 777 storage

# Bring up the environment
sudo docker-compose up -d --build

echo "[+] Environment is up. Vulnerabilities are intentionally present for lab use." 