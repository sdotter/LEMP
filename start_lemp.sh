#!/bin/bash

set -e

# Color and formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color
SEPARATOR="━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Logging function
log_section() {
    # $1 = message, $2 = icon
    echo -e "\n${BLUE}$SEPARATOR${NC}"
    echo -e "${BOLD}${YELLOW}${2:-➜} $1 ${NC}"
    echo -e "${BLUE}$SEPARATOR${NC}"
}

log_section "Checking/updating Docker Compose and Docker" "⚙️"

# Install Docker if missing
if ! command -v docker >/dev/null 2>&1; then
    echo "Docker not found, installing..."
    sudo rm -f /etc/apt/sources.list.d/docker.list
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    ARCH=$(dpkg --print-architecture)
    RELEASE=$(lsb_release -cs)
    echo "deb [arch=$ARCH signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $RELEASE stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
else
    echo "Docker already installed."
fi

# Install Compose fallback if missing (rare with Compose plugin)
if ! docker compose version >/dev/null 2>&1; then
    if ! docker-compose --version >/dev/null 2>&1; then
        echo "No Docker Compose found, installing legacy version..."
        sudo curl -L "https://github.com/docker/compose/releases/download/2.12.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        echo "Legacy Docker Compose installed."
    fi
fi

log_section "Bringing up docker-compose stack" "🚀"
cd "$(dirname "$0")"
if docker compose version >/dev/null 2>&1; then
    sudo docker compose up -d
else
    sudo docker-compose up -d
fi

log_section "Waiting for MariaDB to be ready" "⏳"
MAX_TRIES=30
TRIES=0
while ! sudo docker exec -i mydb /bin/bash -c "mysqladmin ping -u root --password='12345' --silent" 2>/dev/null | grep -q "mysqld is alive"; do
    sleep 1
    TRIES=$((TRIES+1))
    if [ "$TRIES" -ge "$MAX_TRIES" ]; then
        echo -e "${RED}MariaDB did not become ready in time. Exiting.${NC}"
        exit 1
    fi
done

log_section "Setting MariaDB root password" "🔑"
sudo docker exec -i mydb /bin/bash -c "mysqladmin -u root -p'12345' password '12345'"
log_section "MariaDB root password set" "✔️"

log_section "Docker container status" "📦"
sudo docker ps
log_section "Done" "🏁"
echo -e "\n${GREEN}Go to: https://localhost/   (your web root)${NC}"
echo -e "${GREEN}Go to: https://localhost/phpmyadmin   (phpMyAdmin)${NC}\n"

# import database example
# sudo docker cp backup.sql mydb:/backup.sql
# sudo docker exec -i mydb /bin/bash -c "mysql -u root -p'12345' < /backup.sql"