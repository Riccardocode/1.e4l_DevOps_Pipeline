#!/bin/bash

# Define paths to backend and frontend repositories
BACKEND_PATH="$HOME/stage-backend"

# Function to install Docker
install_docker() {
    if ! command -v docker &> /dev/null; then
        echo "Docker not found. Installing Docker..."
        sudo apt-get update
        sudo apt-get install -y \
            apt-transport-https \
            ca-certificates \
            curl \
            software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository \
            "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        sudo apt-get update
        sudo apt-get install -y docker-ce
        sudo systemctl start docker
        sudo systemctl enable docker
        echo "Docker installed successfully."
    else
        echo "Docker is already installed."
    fi
}

# Function to install Docker Compose
install_docker_compose() {
    if ! command -v docker-compose &> /dev/null; then
        echo "Docker Compose not found. Installing Docker Compose..."
        sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        echo "Docker Compose installed successfully."
    else
        echo "Docker Compose is already installed."
    fi
}

# Install Docker and Docker Compose if needed
install_docker
install_docker_compose

# Create the e4l-mysql directory if it doesn't exist and set permissions
if [ ! -d "${HOME}/e4l-mysql" ]; then
    echo "Creating ${HOME}/e4l-mysql directory..."
    sudo mkdir -p "${HOME}/e4l-mysql"
fi
sudo chmod -R 777 "${HOME}/e4l-mysql"

# Step 1: Start the Database Container
echo "Starting the database container..."
cd "$BACKEND_PATH" || exit
sudo docker-compose -f ./docker-compose.db.yml up -d
echo "Database started..."

# Step 2: Start the Backend Container
echo "Starting the backend container..."
cd "$BACKEND_PATH" || exit
sudo docker-compose -f ./docker-compose.backend.pre-prod.yml up -d
echo "Backend started..."
