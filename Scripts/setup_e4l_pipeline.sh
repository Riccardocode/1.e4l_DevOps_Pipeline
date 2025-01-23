#This file is used to start the pipeline and the 3 environments (Integration, Stage, Production) 
#It will check if all the dependencies are installed in the correct version
#If not, it will install them. In case a version is different, It will remove the present and install the correct version
#After the installation is completed, it will start the 3 environments and set up the backend and frontend repositories
#The environments are started with ./start_environments.sh
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

VAGRANT_LINK="https://releases.hashicorp.com/vagrant/2.3.7/vagrant_2.3.7-1_amd64.deb"

# Define paths for downloads
INSTALLATION_DIR=~/1.e4l_DevOps_Pipeline/data/installations
GITLAB_RUNNER_FILE=$INSTALLATION_DIR/gitlab-runner_17.5.3-1_amd64.deb
DOCKER_CLI_FILE=$INSTALLATION_DIR/docker-ce-cli_19.03.15~3-0~ubuntu-xenial_amd64.deb
CONTAINERD_FILE=$INSTALLATION_DIR/containerd.io_1.3.7-1_amd64.deb
DOCKER_COMPOSE_FILE=$INSTALLATION_DIR/docker-compose-linux-x86_64

# Ensure the installation directory exists
mkdir -p "$INSTALLATION_DIR"


## Function to check and install a specific version of a tool
check_and_install() {
  # Parameters
  local tool="$1"                # The name of the tool (e.g., git, vagrant)
  local required_version="$2"    # The required version of the tool
  local install_command="$3"     # The command to install the required version
  local version_command="$4"     # The command to check the currently installed version

  # Step 1: Notify that the script is checking for the tool
  echo "Checking $tool..."

  # Step 2: Check if the tool is installed
  if command -v "$tool" &> /dev/null; then
    # If installed, retrieve the currently installed version
    installed_version=$($version_command | grep -Eo "[0-9]+(\.[0-9]+)+" | head -1)

    # Step 3: Compare the installed version with the required version
    if [[ "$installed_version" != "$required_version" ]]; then
      # If the versions do not match, notify the user
      echo -e "${YELLOW}[Warning] $tool version mismatch. Installed: $installed_version, Required: $required_version.${NC}"

      # Step 4: Remove the currently installed version
      echo "Removing old version of $tool..."
      sudo apt-get remove --purge -y "$tool"

      # Step 5: Install the required version of the tool
      echo "Installing $tool version $required_version..."
      eval "$install_command"
    else
      # If the versions match, notify the user that the correct version is installed
      echo -e "${GREEN}[OK] $tool version $required_version is installed.${NC}"
    fi
  else
    # Step 6: If the tool is not installed, notify the user and install it
    echo -e "${RED}[Error] $tool is not installed. Installing...${NC}"
    eval "$install_command"
  fi
}

#Installing those programs can overcomplicate the process
#So the installation of them will be left to the user manually.
# # Check and install Git
# check_and_install "git" "$REQUIRED_GIT_VERSION" \
#   "sudo apt-get update && sudo apt-get install -y git=$REQUIRED_GIT_VERSION*" \
#   "git --version"

# # Check and install VirtualBox
# check_and_install "virtualbox" "$REQUIRED_VBOX_VERSION" \
#   "wget -q https://download.virtualbox.org/virtualbox/$REQUIRED_VBOX_VERSION/virtualbox-$REQUIRED_VBOX_VERSION_amd64.deb && sudo dpkg -i virtualbox-$REQUIRED_VBOX_VERSION_amd64.deb && sudo apt-get -f install -y" \
#   "virtualbox --version"

# # Check and install Vagrant
# check_and_install "vagrant" "$REQUIRED_VAGRANT_VERSION" \
#   "wget https://releases.hashicorp.com/vagrant/$REQUIRED_VAGRANT_VERSION/vagrant_${REQUIRED_VAGRANT_VERSION}_linux_amd64.zip -O /tmp/vagrant_${REQUIRED_VAGRANT_VERSION}_linux_amd64.zip && \
#   sudo unzip -o /tmp/vagrant_${REQUIRED_VAGRANT_VERSION}_linux_amd64.zip -d /usr/local/bin && \
#   sudo chmod +x /usr/local/bin/vagrant && \
#   rm -f /tmp/vagrant_${REQUIRED_VAGRANT_VERSION}_linux_amd64.zip" \
#   "vagrant --version"


# # Check and install Ansible
# check_and_install "ansible" "$REQUIRED_ANSIBLE_VERSION" \
#   "sudo apt-get update && sudo apt-get install -y ansible=$REQUIRED_ANSIBLE_VERSION*" \
#   "ansible --version"

#Those downloads help to reduce time when installing the envonments.
#By reusing the same installation file and avoiding to download it again
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
cd ~/1.e4l_DevOps_Pipeline/Scripts || exit
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