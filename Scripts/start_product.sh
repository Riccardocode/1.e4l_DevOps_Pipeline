#!/bin/bash

# Define paths to backend and frontend repositories
BACKEND_PATH="$HOME/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.api.dev"
FRONTEND_PATH="$HOME/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.frontend.dev"

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
