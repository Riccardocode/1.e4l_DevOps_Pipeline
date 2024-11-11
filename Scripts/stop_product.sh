#!/bin/bash

# Define paths to backend and frontend repositories
BACKEND_PATH="$HOME/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.api.dev"
FRONTEND_PATH="$HOME/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.frontend.dev"

# Step 1: Stop the Database Container
echo "Stopping the database container..."
cd "$BACKEND_PATH" || exit
sudo docker-compose -f ./docker/docker-compose.db.yml down

# Step 2: Stop the Backend Container
echo "Stopping the backend container..."
cd "$BACKEND_PATH" || exit
sudo docker-compose -f ./docker/docker-compose.backend.pre-prod.yml down

# Step 3: Stop the Frontend Container
echo "Stopping the frontend container..."
cd "$FRONTEND_PATH" || exit
sudo docker-compose -f ./e4l.frontend.docker/docker-compose.frontend.pre-prod.yml down

echo "All containers have been stopped."
