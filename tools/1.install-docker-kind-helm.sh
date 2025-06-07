#!/bin/bash

set -e

echo "Updating existing list of packages..."
sudo apt-get update

echo "Installing prerequisites..."
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo "Adding Docker's official GPG key..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "Adding Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Updating package index with Docker packages..."
sudo apt-get update

echo "Installing Docker Engine..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Enabling Docker service to start on boot..."
sudo systemctl enable docker

echo "Starting Docker service..."
sudo systemctl start docker

echo "Adding current user to docker group (you may need to log out and log back in)..."
sudo usermod -aG docker $USER

echo "Docker installation completed successfully."
docker --version

echo "Installing prerequisites..."
sudo apt-get update
sudo apt-get install -y curl

echo "Installing prerequisites..."
sudo apt-get update
sudo apt-get install -y curl gnupg

echo "Adding Helm GPG key..."
curl https://baltocdn.com/helm/signing.asc | sudo gpg --dearmor -o /usr/share/keyrings/helm.gpg

echo "Adding Helm APT repository..."
echo "deb [signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | \
  sudo tee /etc/apt/sources.list.d/helm-stable-debian.list > /dev/null

echo "Updating package list..."
sudo apt-get update

echo "Installing Helm..."
sudo apt-get install -y helm

echo "Verifying Helm installation..."
helm version

echo "Helm installed successfully."
