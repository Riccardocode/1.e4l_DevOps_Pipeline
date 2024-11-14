#!/bin/bash

# Install GitLab Runner
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get install -y gitlab-runner

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
  --description "[stage-backend] shell" \
  --tag-list "stage-vm-backend-shell" \
  --executor "shell" \
  --run-untagged="true"

# Register the GitLab Runner for frontend with shell executor
sudo gitlab-runner register \
  --non-interactive \
  --url "http://192.168.56.9/gitlab/" \
  --registration-token "$token" \
  --description "[stage-frontend] shell" \
  --tag-list "stage-vm-frontend-shell" \
  --executor "shell" \
  --run-untagged="true"

# Update the privileged setting in config.toml
CONFIG_FILE="/etc/gitlab-runner/config.toml"
sudo sed -i 's/privileged = false/privileged = true/' "$CONFIG_FILE"

