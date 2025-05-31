#!/bin/bash
# This script installs Docker on an Ubuntu system and configures it for use with Vagrant.

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker Engine, containerd, and Docker Compose:
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Forces the Docker group to be created if it does not exist:
if ! getent group docker > /dev/null; then
  sudo groupadd docker
fi

# Add Vagrant to the Docker group to allow running Docker commands without sudo:
sudo usermod -aG docker vagrant

# Reload the group membership for the vagrant user to allow immediate access to Docker commands:
exec sudo su - vagrant -c "newgrp docker"
