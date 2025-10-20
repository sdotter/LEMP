#!/bin/bash

# This script stops and removes all Docker containers for the LEMP stack
set -e

cd "$(dirname "$0")"

# Stop and remove all containers defined in docker-compose.yml
if command -v docker compose >/dev/null 2>&1; then
    sudo docker compose down --volumes --remove-orphans
elif command -v docker-compose >/dev/null 2>&1; then
    sudo docker-compose down --volumes --remove-orphans
else
    echo "Docker Compose not found"
fi

# Remove all stopped containers (optional, for full cleanup)
sudo docker container prune -f

echo "All LEMP containers and volumes removed."
