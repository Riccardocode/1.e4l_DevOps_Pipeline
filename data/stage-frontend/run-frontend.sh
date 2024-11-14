#!/bin/bash

# Define paths to  frontend repositories
FRONTEND_PATH="$HOME/stage-frontend"

# Create the e4l-news directory if it doesn't exist and set permissions
if [ ! -d "${HOME}/e4l-news" ]; then
    echo "Creating ${HOME}/e4l-news directory..."
    sudo mkdir -p "${HOME}/e4l-news"
    
fi
sudo chmod -R 777 "${HOME}/e4l-news"

# Step 1: Start the Frontend Container
echo "Starting the frontend container..."
cd "$FRONTEND_PATH" || exit
sudo docker-compose -f ./e4l.frontend.docker/docker-compose.frontend.pre-prod.yml up -d

echo "frontend have been started."
