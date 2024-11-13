#!/bin/bash

# Set paths
BACKEND_REPO_PATH="./"
CONTAINER_NAME="e4l-backend-preprod"
DOCKER_IMAGE="gradle:8.3"

# Check if BACKEND_REPO_PATH exists
if [ ! -d "$BACKEND_REPO_PATH" ]; then
    echo "Error: Backend repository path $BACKEND_REPO_PATH does not exist."
    exit 1
fi

# Verify the presence of Gradle files
if [ -f "$BACKEND_REPO_PATH/settings.gradle" ] || [ -f "$BACKEND_REPO_PATH/settings.gradle.kts" ]; then
    APP_SOURCE_PATH="$BACKEND_REPO_PATH"
elif [ -f "$BACKEND_REPO_PATH/src/settings.gradle" ] || [ -f "$BACKEND_REPO_PATH/src/settings.gradle.kts" ]; then
    APP_SOURCE_PATH="$BACKEND_REPO_PATH/src"
else
    echo "Error: No Gradle build files found in $BACKEND_REPO_PATH or a 'src' subdirectory."
    exit 1
fi

# Step 1.1 - Check if the Docker image is already present
if sudo docker images | grep -q "$DOCKER_IMAGE"; then
    echo "Docker image $DOCKER_IMAGE is already present."
else
    echo "Pulling Gradle Docker image..."
    sudo docker pull $DOCKER_IMAGE
fi

# Check if container already exists and remove it if necessary
if sudo docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}$"; then
    echo "Removing existing container $CONTAINER_NAME..."
    sudo docker rm -f $CONTAINER_NAME
fi

# Step 1.2 - Create container with the Gradle image
echo "Creating a container with the Gradle image..."
sudo docker run -d --name $CONTAINER_NAME $DOCKER_IMAGE tail -f /dev/null

# Step 1.3 - Copy app folder into the container
echo "Copying source code to container..."
sudo docker cp "$APP_SOURCE_PATH/." $CONTAINER_NAME:/app || { echo "Error copying source code. Exiting."; exit 1; }

# Step 1.4 & 1.5 - Run commands inside the container to build the JAR file
echo "Building JAR file inside the container..."
sudo docker exec -it $CONTAINER_NAME bash -c "
    cd /app &&
    gradle wrapper &&
    chmod +x gradlew &&
    ./gradlew clean build bootJar -Dorg.gradle.jvmargs='-Xmx2g -Xms512m'
" || { echo "Error during JAR file build. Exiting."; exit 1; }

# Ensure the host build directory exists with correct permissions
echo "Ensuring correct permissions for build directory on host..."
sudo mkdir -p "$BACKEND_REPO_PATH/build/libs"
sudo chmod -R 755 "$BACKEND_REPO_PATH/build"

# Step 1.6 - Copy the built JAR file to the host
echo "Copying JAR file to host..."
sudo docker cp "$CONTAINER_NAME:/app/build/libs/." "$BACKEND_REPO_PATH/build/libs" || { echo "Error copying JAR file to host. Exiting."; exit 1; }


# Step 1.7 - Stop and remove the container
echo "Cleaning up by removing the container..."
sudo docker stop $CONTAINER_NAME
sudo docker rm $CONTAINER_NAME

# Step 2 - Build the Docker image using the correct build context
echo "Building the backend Docker image..."
sudo docker build -t lu.uni.e4l.platform.backend.dev:rc "$BACKEND_REPO_PATH" || { echo "Error during Docker image build. Exiting."; exit 1; }

echo "Process completed. The JAR file is located in $BACKEND_REPO_PATH/build/libs, and the Docker image has been built."

