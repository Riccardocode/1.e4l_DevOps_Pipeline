#!/bin/bash

# Desired versions
DOCKER_VERSION="24.0.5"
DOCKER_COMPOSE_VERSION="v2.20.3"

# Function to check Docker version
check_docker_version() {
    if command -v docker &> /dev/null; then
        INSTALLED_DOCKER_VERSION=$(docker --version | grep -oP '\d+\.\d+\.\d+')
        if [ "$INSTALLED_DOCKER_VERSION" = "$DOCKER_VERSION" ]; then
            echo "Docker $DOCKER_VERSION is already installed."
            return 0
        else
            echo "Docker version $INSTALLED_DOCKER_VERSION is installed, but $DOCKER_VERSION is required."
            return 1
        fi
    else
        echo "Docker is not installed."
        return 1
    fi
}

# Function to install Docker
install_docker() {
    echo "Installing Docker $DOCKER_VERSION..."
    sudo apt-get update
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce="$DOCKER_VERSION~3-0~$(lsb_release -cs)" docker-ce-cli="$DOCKER_VERSION~3-0~$(lsb_release -cs)" containerd.io
    sudo systemctl enable docker
    sudo systemctl start docker
    echo "Docker $DOCKER_VERSION installed successfully."
}

# Function to check Docker Compose version
check_docker_compose_version() {
    if command -v docker-compose &> /dev/null; then
        INSTALLED_COMPOSE_VERSION=$(docker-compose --version | grep -oP 'v\d+\.\d+\.\d+')
        if [ "$INSTALLED_COMPOSE_VERSION" = "$DOCKER_COMPOSE_VERSION" ]; then
            echo "Docker Compose $DOCKER_COMPOSE_VERSION is already installed."
            return 0
        else
            echo "Docker Compose version $INSTALLED_COMPOSE_VERSION is installed, but $DOCKER_COMPOSE_VERSION is required."
            return 1
        fi
    else
        echo "Docker Compose is not installed."
        return 1
    fi
}

# Function to install Docker Compose
install_docker_compose() {
    echo "Installing Docker Compose $DOCKER_COMPOSE_VERSION..."
    sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose $DOCKER_COMPOSE_VERSION installed successfully."
}

# Check and install Docker if necessary
if ! check_docker_version; then
    install_docker
fi

# Check and install Docker Compose if necessary
if ! check_docker_compose_version; then
    install_docker_compose
fi

echo "Docker and Docker Compose setup is complete."
