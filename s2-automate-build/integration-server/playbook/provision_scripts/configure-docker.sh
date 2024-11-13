# Add user to the docker group to access the CLI
sudo usermod -aG docker vagrant

# Check if the usermod command was successful
if [ $? -ne 0 ]; then
  echo -e "\n\033[0;31mFailed to add user to docker group; Quitting\033[0m\n"
  exit 1
fi

# Validate the installation by running the hello world example
count=$(docker run --rm --name hello-world hello-world | grep -c "Hello from Docker!")

if [ "$count" -ne 1 ]; then
  echo -e "\n\033[0;31mDocker validation failed; Quitting\033[0m\n"
  exit 1
fi

echo -e "\n\033[0;32mDocker validation succeeded!\033[0m\n"

# Remove the hello-world image after validation
docker rmi -f hello-world

