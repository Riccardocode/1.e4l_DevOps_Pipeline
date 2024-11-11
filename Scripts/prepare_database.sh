#!/bin/bash

# Check if the specified MariaDB image exists locally
if sudo docker images | grep -q "mariadb.*10.4.7"; then
    echo "MariaDB 10.4.7 image is already pulled."
else
    echo "MariaDB 10.4.7 image not found. Pulling now..."
    sudo docker pull mariadb:10.4.7

    # Check if the pull was successful
    if [ $? -eq 0 ]; then
        echo "MariaDB 10.4.7 image successfully pulled."
    else
        echo "Failed to pull MariaDB 10.4.7 image."
    fi
fi
