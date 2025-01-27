#!/bin/bash

# Define paths to backend and frontend repositories
BACKEND_PATH="/home/vagrant/deploy-backend"
# Define the Docker image and container name
IMAGE_NAME="lu.uni.e4l.platform.backend.dev:rc"
CONTAINER_NAME="e4l-backend-preprod"

# Ensure the backend path exists
if [ ! -d "$BACKEND_PATH" ]; then
    echo "Error: Backend path '$BACKEND_PATH' does not exist."
    exit 1
fi

# Build the Docker image
echo "Building the Docker image..."
docker build -t "$IMAGE_NAME" "$BACKEND_PATH"
if [ $? -ne 0 ]; then
    echo "Error: Docker image build failed."
    exit 1
fi

# Check if the container (running or stopped) exists
if docker ps -a --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    echo "Container '${CONTAINER_NAME}' exists. Stopping and removing it..."
    docker stop "${CONTAINER_NAME}" 2>/dev/null || true  # Stop only if running
    docker rm "${CONTAINER_NAME}" || {
        echo "Error: Failed to remove the container."
        exit 1
    }
else
    echo "Container '${CONTAINER_NAME}' does not exist."
fi

# Start the container
echo "Starting the container..."
docker run -d --name "${CONTAINER_NAME}" "$IMAGE_NAME" || {
    echo "Error: Failed to start the container."
    exit 1
}
# docker start -d --name "${CONTAINER_NAME}" "$IMAGE_NAME" || {
#     echo "Error: Failed to start the container."
#     exit 1
# }

echo "Script executed successfully!"
