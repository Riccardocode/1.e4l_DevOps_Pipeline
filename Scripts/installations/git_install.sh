#!/bin/bash

# Desired Git version
GIT_VERSION="2.34.1"

# Function to check Git version
check_git_version() {
    if command -v git &> /dev/null; then
        INSTALLED_GIT_VERSION=$(git --version | awk '{print $3}')
        if [ "$INSTALLED_GIT_VERSION" = "$GIT_VERSION" ]; then
            echo "Git $GIT_VERSION is already installed."
            return 0
        else
            echo "Git version $INSTALLED_GIT_VERSION is installed, but $GIT_VERSION is required."
            return 1
        fi
    else
        echo "Git is not installed."
        return 1
    fi
}

# Function to install Git
install_git() {
    echo "Installing Git $GIT_VERSION..."

    # Add PPA for newer Git versions
    sudo add-apt-repository ppa:git-core/ppa -y
    sudo apt-get update

    # Install specific Git version
    sudo apt-get install -y git="$GIT_VERSION*"
    
    # Verify installation
    INSTALLED_GIT_VERSION=$(git --version | awk '{print $3}')
    if [ "$INSTALLED_GIT_VERSION" = "$GIT_VERSION" ]; then
        echo "Git $GIT_VERSION installed successfully."
    else
        echo "Failed to install Git $GIT_VERSION. Installed version is $INSTALLED_GIT_VERSION."
        exit 1
    fi
}

# Check and install/update Git if necessary
if ! check_git_version; then
    install_git
fi

echo "Git setup is complete."
