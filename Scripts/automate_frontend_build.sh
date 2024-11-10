#!/bin/bash

# Set paths
FRONTEND_REPO_PATH="$HOME/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.frontend.dev"
CONTAINER_NAME="e4l-frontend-preprod"
WEB_PATH="$FRONTEND_REPO_PATH/e4l.frontend.docker/web"
DIST_PATH="$WEB_PATH/dist"
NODE_IMAGE="node:15"
NGINX_IMAGE="nginx:1.13.5"

mkdir -p "$WEB_PATH"
sudo chmod -R 777 "$WEB_PATH"

# Step 1.1 - Pull the Node image
echo "Pulling Node Docker image..."
sudo docker pull $NODE_IMAGE

# Check if container already exists and remove it if necessary
if sudo docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}$"; then
    echo "Removing existing container $CONTAINER_NAME..."
    sudo docker rm -f $CONTAINER_NAME
fi

# Step 1.2 - Create container with Node image
echo "Creating a container with the Node image..."
sudo docker run -d --name $CONTAINER_NAME $NODE_IMAGE tail -f /dev/null

# Step 1.3 - Copy app folder into the container
echo "Copying source code to container..."
sudo docker cp "$FRONTEND_REPO_PATH/." $CONTAINER_NAME:/app || { echo "Error copying source code. Exiting."; exit 1; }

# Step 1.4 & 1.5 - Run npm commands inside the container
echo "Installing dependencies and building frontend inside the container..."
sudo docker exec -it $CONTAINER_NAME bash -c "
    cd /app &&
    npm install --save-dev webpack &&
    npm run build
    chmod -R 755 /app/e4l.frontend.docker/web/dist
" || { echo "Error during frontend build. Exiting."; exit 1; }

# Ensure the host web directory exists with correct permissions


# Step 1.6 - Ensure the dist folder is clean before copying
if [ -d "$DIST_PATH" ]; then
    echo "Removing existing dist folder..."
    sudo rm -rf "$DIST_PATH"
fi
mkdir -p "$DIST_PATH"
sudo chmod -R 777 "$DIST_PATH"
# Copy the new dist folder from the container to the host
echo "Copying dist folder to host..."
sudo docker cp "$CONTAINER_NAME:/app/e4l.frontend.docker/web/dist/." "$DIST_PATH" || { echo "Error copying dist folder to host. Exiting."; exit 1; }

# Step 1.7 - Remove the Node container
echo "Cleaning up by removing the frontend container..."
sudo docker stop $CONTAINER_NAME
sudo docker rm $CONTAINER_NAME

# Step 2 - Pull the nginx image
echo "Pulling Nginx Docker image..."
sudo docker pull $NGINX_IMAGE

# Step 3 - Build the Docker image for the frontend
#This part may be addressed later in the pipeline, when deploying the frontend
echo "Building the frontend Docker image..."
sudo docker build -t lu.uni.e4l.platform.frontend.dev:rc "$WEB_PATH" || { echo "Error during frontend Docker image build. Exiting."; exit 1; }

echo "Frontend build and Docker image creation completed."
