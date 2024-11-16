#!/bin/bash 

#This script can be separated into two scripts,
#One to install gitlab-runner and one to register the runners
# Define paths and package name
INSTALLATION_DIR="/vagrant_data/installations"
PACKAGE_NAME="gitlab-runner_17.5.3-1_amd64.deb" 
PACKAGE_PATH="$INSTALLATION_DIR/$PACKAGE_NAME"

# # Previous Install GitLab Runner from internet
# curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
# sudo apt-get install -y gitlab-runner

# Check if the package exists in the shared folder
if [ ! -f "$PACKAGE_PATH" ]; then
  echo "Error: GitLab Runner package not found at $PACKAGE_PATH."
  exit 1
fi

# Install GitLab Runner from the pre-downloaded package
sudo dpkg -i "$PACKAGE_PATH"
# Resolve any missing dependencies
sudo apt-get install -f -y

# Retrieve the runner registration token (only if this is run on the GitLab server)
# If not on the GitLab server, copy the token from GitLab UI: Settings > CI / CD > Runners
token=$(sudo gitlab-rails runner -e production "puts Gitlab::CurrentSettings.current_application_settings.runners_registration_token")

# Save the token to a file in /vagrant_data
echo "$token" > /vagrant_data/gitlab_runner_token.txt

# Check if token retrieval was successful
if [ -z "$token" ]; then
  echo "Error: Failed to retrieve the runner registration token. Please ensure the token is set correctly."
  exit 1
fi

# Register the GitLab Runner
sudo gitlab-runner register \
  --non-interactive \
  --url "http://192.168.56.9/gitlab/" \
  --registration-token "$token" \
  --description "docker-runner-backend" \
  --tag-list "e4l-backend" \
  --executor "docker" \
  --docker-image "alpine:latest" \
  --run-untagged="true"

sudo gitlab-runner register \
  --non-interactive \
  --url "http://192.168.56.9/gitlab/" \
  --registration-token "$token" \
  --description "docker-runner-frontend" \
  --tag-list "e4l-frontend" \
  --executor "docker" \
  --docker-image "alpine:latest" \
  --run-untagged="true"


# Update the privileged setting in config.toml
CONFIG_FILE="/etc/gitlab-runner/config.toml"
sudo sed -i 's/privileged = false/privileged = true/' "$CONFIG_FILE"


sudo gitlab-runner restart

