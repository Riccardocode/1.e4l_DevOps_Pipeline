#!/bin/bash

# Variables
GITLAB_URL="http://192.168.56.9/gitlab"
PRIVATE_TOKEN="ypCa3b2bz3o5nvsixwPP"
PROJECT_NAME="e4l-frontend"
PROJECT_DESCRIPTION="This is the e4l frontend project"
VISIBILITY="private"  # Set to "public" if you want a public project

# Create the project on GitLab using the API
response=$(curl --silent --write-out "%{http_code}" --header "PRIVATE-TOKEN: $PRIVATE_TOKEN" \
  -X POST "$GITLAB_URL/api/v4/projects" \
  --data "name=$PROJECT_NAME" \
  --data "path=$PROJECT_NAME" \
  --data-urlencode "description=$PROJECT_DESCRIPTION" \
  --data "visibility=$VISIBILITY")

# Extract HTTP status code and response body
http_status="${response: -3}"
response_body="${response%$http_status}"

Check if project creation was successful
if [ "$http_status" -eq 201 ]; then
  echo "Project '$PROJECT_NAME' created successfully!"
else
  echo -e "\n\033[0;31mFailed to create project. HTTP Status: $http_status\033[0m"
  echo "Response: $response_body"
  exit 1
fi

# Initialize a local Git repository
cd ~/1.e4l_DevOps_Pipeline/s1-create-skeleton/lu.uni.e4l.platform.frontend.dev
git init

# Check if the origin remote already exists and remove it if it does
if git remote get-url origin &>/dev/null; then
  git remote remove origin
  echo "Existing remote 'origin' removed."
fi

# Add the new origin remote
git remote add origin http://projectowner:projectowner@192.168.56.9/gitlab/ProjectOwner/$PROJECT_NAME.git

echo "New remote 'origin' added."

# Configure the Git user
git config --global user.name "ProjectOwner"
git config --global user.email "projectowner@company.com"

# Create a .gitignore file
echo '# Binaries
target/

# Log files
*log

# Dev settings
.settings/' > .gitignore

# Add, commit, and push the project
git add .
git commit -m "Initial Commit"
git push -u origin master

