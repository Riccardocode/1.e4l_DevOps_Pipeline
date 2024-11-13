#!/bin/bash

# Define paths to backend and frontend repositories
BACKEND_PATH="$HOME/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.api.dev"
FRONTEND_PATH="$HOME/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.frontend.dev"

# Create the e4l-mysql directory if it doesn't exist and set permissions
if [ ! -d "${HOME}/e4l-mysql" ]; then
    echo "Creating ${HOME}/e4l-mysql directory..."
    sudo mkdir -p "${HOME}/e4l-mysql"
    
fi
sudo chmod -R 777 "${HOME}/e4l-mysql"

# Create the e4l-news directory if it doesn't exist and set permissions
if [ ! -d "${HOME}/e4l-news" ]; then
    echo "Creating ${HOME}/e4l-news directory..."
    sudo mkdir -p "${HOME}/e4l-news"
    
fi
sudo chmod -R 777 "${HOME}/e4l-news"

# Step 1: Start the Database Container
echo "Starting the database container..."
cd "$BACKEND_PATH" || exit
sudo docker-compose -f ./docker/docker-compose.db.yml up -d

# Step 2: Start the Backend Container
echo "Starting the backend container..."
cd "$BACKEND_PATH" || exit
sudo docker-compose -f ./docker/docker-compose.backend.pre-prod.yml up -d

# Step 3: Start the Frontend Container
echo "Starting the frontend container..."
cd "$FRONTEND_PATH" || exit
sudo docker-compose -f ./e4l.frontend.docker/docker-compose.frontend.pre-prod.yml up -d

echo "All containers have been started."
