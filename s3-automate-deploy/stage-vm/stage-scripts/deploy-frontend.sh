#!/bin/bash

# Define paths to frontend repositories
FRONTEND_PATH="/home/vagrant/deploy-frontend"

# Define the Docker image and container name
IMAGE_NAME="lu.uni.e4l.platform.frontend.dev:rc"
CONTAINER_NAME="e4l-frontend-preprod"

# Create the e4l-news directory if it doesn't exist and set permissions
if [ ! -d "${HOME}/e4l-news" ]; then
    echo "Creating ${HOME}/e4l-news directory..."
    sudo mkdir -p "${HOME}/e4l-news"
fi
sudo chmod -R 777 "${HOME}/e4l-news"

# Navigate to the frontend path
cd "$FRONTEND_PATH" || exit

# Build the Docker image
echo "Building the Docker image..."
sudo docker build -t "$IMAGE_NAME" ./web/.

# Check for the container using an exact match
if sudo docker ps --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    echo "Container '${CONTAINER_NAME}' is running. Stopping and removing it..."
    sudo docker stop "${CONTAINER_NAME}"
    sudo docker rm "${CONTAINER_NAME}"
else
    echo "Container '${CONTAINER_NAME}' is not running."
fi

# Run the container using Docker Compose
echo "Starting the frontend container..."
docker-compose -f ./docker-compose.frontend.pre-prod.yml up -d
