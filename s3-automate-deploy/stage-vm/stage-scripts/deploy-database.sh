#!/bin/bash

$BACKEND_PATH="/home/vagrant/deploy-backend"

# Check if the specified MariaDB image exists locally
if docker images | grep -q "mariadb.*10.4.7"; then
    echo "MariaDB 10.4.7 image is already pulled."
else
    echo "MariaDB 10.4.7 image not found. Pulling now..."
    docker pull mariadb:10.4.7

    # Check if the pull was successful
    if [ $? -eq 0 ]; then
        echo "MariaDB 10.4.7 image successfully pulled."
    else
        echo "Failed to pull MariaDB 10.4.7 image."
    fi
fi

# Create the e4l-mysql directory if it doesn't exist and set permissions
if [ ! -d "/home/vagrant/e4l-mysql" ]; then
    echo "Creating /home/vagrant/e4l-mysql directory..."
    mkdir -p "/home/vagrant/e4l-mysql"
    
fi
chmod -R 777 "/home/vagrant/e4l-mysql"

# Create the e4l-news directory if it doesn't exist and set permissions
if [ ! -d "/home/vagrant/e4l-news" ]; then
    echo "Creating /home/vagrant/e4l-news directory..."
    mkdir -p "/home/vagrant/e4l-news"
fi
chmod -R 777 "/home/vagrant/e4l-news"


# Step 1: Start the Database Container
echo "Starting the database container..."
cd "$BACKEND_PATH" || exit
docker-compose -f /home/vagrant/deploy-backend/docker-compose.db.yml up -d