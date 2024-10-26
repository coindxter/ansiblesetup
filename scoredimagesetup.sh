#!/bin/bash

# Ensure openssh-server is installed
if ! dpkg -s openssh-server >/dev/null 2>&1; then
  echo "openssh-server is not installed. Installing now..."
  sudo apt update
  sudo apt install -y openssh-server
else
  echo "openssh-server is already installed."
fi

# Path to the SSH configuration file
SSHD_CONFIG="/etc/ssh/sshd_config"

# Uncomment the necessary lines in sshd_config
sudo sed -i '/^#\?PubkeyAuthentication/s/^#//' $SSHD_CONFIG
sudo sed -i '/^#\?AuthorizedKeysFile/s/^#//' $SSHD_CONFIG

# Restart SSH service to apply changes
sudo systemctl restart ssh

echo "SSH configuration updated to allow public key authentication and restarted."
