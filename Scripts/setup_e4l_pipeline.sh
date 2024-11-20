#!/bin/bash

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Define required versions
REQUIRED_GIT_VERSION="2.34.1"
REQUIRED_VBOX_VERSION="7.0"
REQUIRED_VAGRANT_VERSION="2.3.7"
REQUIRED_ANSIBLE_VERSION="2.10.8"

# Define paths for downloads
INSTALLATION_DIR=~/1.e4l_DevOps_Pipeline/data/installations
GITLAB_RUNNER_FILE=$INSTALLATION_DIR/gitlab-runner_17.5.3-1_amd64.deb
DOCKER_CLI_FILE=$INSTALLATION_DIR/docker-ce-cli_19.03.15~3-0~ubuntu-xenial_amd64.deb
CONTAINERD_FILE=$INSTALLATION_DIR/containerd.io_1.3.7-1_amd64.deb
DOCKER_COMPOSE_FILE=$INSTALLATION_DIR/docker-compose-linux-x86_64

# Ensure the installation directory exists
mkdir -p "$INSTALLATION_DIR"


# Function to check and install a specific version of a tool
check_and_install() {
  local tool="$1"
  local required_version="$2"
  local install_command="$3"
  local version_command="$4"

  echo "Checking $tool..."
  if command -v "$tool" &> /dev/null; then
    installed_version=$($version_command | grep -Eo "[0-9]+(\.[0-9]+)+" | head -1)
    if [[ "$installed_version" != "$required_version" ]]; then
      echo -e "${YELLOW}[Warning] $tool version mismatch. Installed: $installed_version, Required: $required_version.${NC}"
      echo "Removing old version of $tool..."
      sudo apt-get remove --purge -y "$tool"
      echo "Installing $tool version $required_version..."
      eval "$install_command"
    else
      echo -e "${GREEN}[OK] $tool version $required_version is installed.${NC}"
    fi
  else
    echo -e "${RED}[Error] $tool is not installed. Installing...${NC}"
    eval "$install_command"
  fi
}

# Check and install Git
check_and_install "git" "$REQUIRED_GIT_VERSION" \
  "sudo apt-get update && sudo apt-get install -y git=$REQUIRED_GIT_VERSION*" \
  "git --version"

# Check and install VirtualBox
check_and_install "virtualbox" "$REQUIRED_VBOX_VERSION" \
  "wget -q https://download.virtualbox.org/virtualbox/$REQUIRED_VBOX_VERSION/virtualbox-$REQUIRED_VBOX_VERSION_amd64.deb && sudo dpkg -i virtualbox-$REQUIRED_VBOX_VERSION_amd64.deb && sudo apt-get -f install -y" \
  "virtualbox --version"

# Check and install Vagrant
check_and_install "vagrant" "$REQUIRED_VAGRANT_VERSION" \
  "wget -q https://releases.hashicorp.com/vagrant/$REQUIRED_VAGRANT_VERSION/vagrant_${REQUIRED_VAGRANT_VERSION}_x86_64.deb && sudo dpkg -i vagrant_${REQUIRED_VAGRANT_VERSION}_x86_64.deb && sudo apt-get -f install -y" \
  "vagrant --version"

# Check and install Ansible
check_and_install "ansible" "$REQUIRED_ANSIBLE_VERSION" \
  "sudo apt-get update && sudo apt-get install -y ansible=$REQUIRED_ANSIBLE_VERSION*" \
  "ansible --version"


# Download GitLab Runner
if [ ! -f "$GITLAB_RUNNER_FILE" ]; then
  echo "Downloading GitLab Runner..."
  curl -L --output "$GITLAB_RUNNER_FILE" https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb
else
  echo -e "${GREEN}[OK] GitLab Runner is already downloaded.${NC}"
fi

# Download Docker CLI
if [ ! -f "$DOCKER_CLI_FILE" ]; then
  echo "Downloading Docker CLI..."
  wget -q https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/docker-ce-cli_19.03.15~3-0~ubuntu-xenial_amd64.deb -P "$INSTALLATION_DIR"
else
  echo -e "${GREEN}[OK] Docker CLI is already downloaded.${NC}"
fi

# Download containerd.io
if [ ! -f "$CONTAINERD_FILE" ]; then
  echo "Downloading containerd.io..."
  wget -q https://download.docker.com/linux/ubuntu/dists/xenial/pool/stable/amd64/containerd.io_1.3.7-1_amd64.deb -P "$INSTALLATION_DIR"
else
  echo -e "${GREEN}[OK] containerd.io is already downloaded.${NC}"
fi

# Download Docker Compose
if [ ! -f "$DOCKER_COMPOSE_FILE" ]; then
  echo "Downloading Docker Compose..."
  wget -q https://github.com/docker/compose/releases/download/1.23.2/docker-compose-linux-x86_64 -O "$DOCKER_COMPOSE_FILE"
  chmod +x "$DOCKER_COMPOSE_FILE"
else
  echo -e "${GREEN}[OK] Docker Compose is already downloaded.${NC}"
fi

#start the 3 environments (Integration, Stage, Production)
./start_environments.sh

# Setup the backend repository
BACKEND_REPO="/home/riccardo/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.api.dev"
echo "Setting up the backend repository..."
if [ -d "$BACKEND_REPO" ]; then
  echo -e "${GREEN}[OK] Backend repository is already set up at $BACKEND_REPO.${NC}"
else
  echo "Initializing backend repository setup..."
  ~/1.e4l_DevOps_Pipeline/Scripts/setup-repository-backend.sh
fi

# Setup the frontend repository
FRONTEND_REPO="/home/riccardo/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.frontend.dev"
echo "Setting up the frontend repository..."
if [ -d "$FRONTEND_REPO" ]; then
  echo -e "${GREEN}[OK] Frontend repository is already set up at $FRONTEND_REPO.${NC}"
else
  echo "Initializing frontend repository setup..."
  ~/1.e4l_DevOps_Pipeline/Scripts/setup-repository-frontend.sh
fi


echo -e "${GREEN}All processes completed successfully!${NC}"