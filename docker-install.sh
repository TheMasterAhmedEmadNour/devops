#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root." 
   exit 1
fi

echo "Removing conflicting packages (podman, buildah)..."
dnf remove -y podman buildah

echo "Installing yum-utils and adding Docker repository..."
dnf install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "Installing Docker CE and Docker Compose plugin..."
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Enabling and starting Docker service..."
systemctl enable --now docker

echo "Verifying Docker status..."
systemctl status docker --no-pager

echo "Adding current user to the 'docker' group (optional, requires re-login or newgrp to take effect)..."
usermod -aG docker "$SUDO_USER"

echo "Installation complete. You may need to log out and log back in (or use 'newgrp docker') for group changes to take effect."
echo "Test your installation with: docker run hello-world"
