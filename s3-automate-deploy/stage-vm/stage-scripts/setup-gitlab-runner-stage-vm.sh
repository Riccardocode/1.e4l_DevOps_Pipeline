#!/bin/bash 

# Define paths and package name
INSTALLATION_DIR="/vagrant_data/installations"
PACKAGE_NAME="gitlab-runner_17.5.3-1_amd64.deb" 
PACKAGE_PATH="$INSTALLATION_DIR/$PACKAGE_NAME"

# # Previous Install GitLab Runner from internet
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get install -y gitlab-runner

# Check if the package exists in the shared folder
# if [ ! -f "$PACKAGE_PATH" ]; then
#   echo "Error: GitLab Runner package not found at $PACKAGE_PATH."
#   exit 1
# fi

# # Install GitLab Runner from the pre-downloaded package
# sudo dpkg -i "$PACKAGE_PATH"
# # Resolve any missing dependencies
# sudo apt-get install -f -y

# Configure sudoers for passwordless execution of specific commands
echo "Configuring passwordless sudo for GitLab Runner..."
SUDOERS_LINE="gitlab-runner ALL=(ALL) NOPASSWD: /bin/mkdir, /bin/chmod, /usr/bin/docker"
if ! sudo grep -qF "$SUDOERS_LINE" /etc/sudoers; then
  echo "$SUDOERS_LINE" | sudo tee -a /etc/sudoers
fi

# Add gitlab-runner user to the docker group
echo "Adding gitlab-runner user to the docker group..."
sudo usermod -aG docker gitlab-runner

# Restart GitLab Runner to apply group changes
echo "Restarting GitLab Runner service..."
sudo systemctl restart gitlab-runner


# Retrieve the runner registration token (only if this is run on the GitLab server)
# If not on the GitLab server, copy the token from GitLab UI: Settings > CI / CD > Runners
# token=$(sudo gitlab-rails runner -e production "puts Gitlab::CurrentSettings.current_application_settings.runners_registration_token")
token=$(cat /vagrant_data/gitlab_runner_token.txt)
# Check if token retrieval was successful
if [ -z "$token" ]; then
  echo "Error: Failed to retrieve the runner registration token. Please ensure the token is set correctly."
  exit 1
fi

# Check if the specific runners are already registered and remove them if found
for description in "[stage-backend] shell" "[stage-frontend] shell"; do
  existing_runner=$(sudo gitlab-runner list | grep "$description")
  if [ ! -z "$existing_runner" ]; then
    # Extract the runner ID
    runner_id=$(echo "$existing_runner" | awk '{print $2}')
    echo "Removing existing runner with ID: $runner_id and description: $description"
    sudo gitlab-runner unregister --id "$runner_id"
  fi
done

# Register the GitLab Runner for backend with shell executor
sudo gitlab-runner register \
  --non-interactive \
  --url "http://192.168.56.9/gitlab/" \
  --registration-token "$token" \
  --description "stage-backend-shell" \
  --tag-list "stage-vm-backend-shell" \
  --executor "shell" \
  --run-untagged="true"

# Register the GitLab Runner for frontend with shell executor
sudo gitlab-runner register \
  --non-interactive \
  --url "http://192.168.56.9/gitlab/" \
  --registration-token "$token" \
  --description "stage-frontend-shell" \
  --tag-list "stage-vm-frontend-shell" \
  --executor "shell" \
  --run-untagged="true"

# Update the privileged setting in config.toml
CONFIG_FILE="/etc/gitlab-runner/config.toml"
if sudo grep -q "privileged = false" "$CONFIG_FILE"; then
  echo "Updating privileged setting in $CONFIG_FILE..."
  sudo sed -i 's/privileged = false/privileged = true/' "$CONFIG_FILE"
fi

echo "Restarting GitLab Runner service..."
sudo systemctl restart gitlab-runner

echo "GitLab Runner setup completed successfully!"