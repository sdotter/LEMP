#!/bin/bash

cd "$(dirname "$0")"
if command -v docker compose >/dev/null 2>&1; then
    sudo docker compose down
elif command -v docker-compose >/dev/null 2>&1; then
    docker-compose down
else
    echo "Docker Compose not found"
fi