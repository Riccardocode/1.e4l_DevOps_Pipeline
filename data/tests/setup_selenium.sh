#!/bin/bash

# Update system packages
echo "Updating system packages..."
sudo apt update -y

# Install Python3 pip
echo "Installing Python3 and pip..."
sudo apt install -y python3-pip

# Install Selenium
echo "Installing Selenium..."
pip3 install selenium==3.141.0

# Install Chromium Browser
echo "Installing Chromium browser..."
sudo apt install -y chromium-browser

# Download ChromeDriver
echo "Downloading ChromeDriver..."
wget -q https://chromedriver.storage.googleapis.com/90.0.4430.24/chromedriver_linux64.zip

# Install unzip if not installed
echo "Installing unzip..."
sudo apt install -y unzip

# Unzip and move ChromeDriver to /usr/local/bin/
echo "Installing ChromeDriver..."
unzip chromedriver_linux64.zip
sudo mv chromedriver /usr/local/bin/
sudo chmod +x /usr/local/bin/chromedriver

# Verify ChromeDriver installation
echo "Verifying ChromeDriver installation..."
chromedriver --version

# Install compatible urllib3 version
echo "Installing compatible urllib3 version..."
pip3 install urllib3==1.26.6

echo "Selenium setup completed successfully!"
