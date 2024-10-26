
#Sets up Ansible on the control node

#!/bin/bash

# Install Ansible on the control node
sudo apt update
sudo apt install -y ansible

# Generate SSH key pair
ssh-keygen -t rsa

# Prompt user for the remote IP address
read -p "Enter the remote IP address: " REMOTE_IP_ADDRESS

# Copy SSH key to remote host
ssh-copy-id user@$REMOTE_IP_ADDRESS

# Create a work folder in the home directory and navigate into it
cd ~
mkdir -p work_folder
cd work_folder

# Copy SSH private key to the current directory
cp ~/.ssh/id_rsa $(pwd)

# Test passwordless SSH connection and exit if successful
ssh -i id_rsa user@$REMOTE_IP_ADDRESS "exit"

echo "Passwordless SSH authentication test completed successfully."

# Download the latest Scap Security Guide
wget https://github.com/ComplianceAsCode/content/releases/download/v0.1.73/scap-security-guide-0.1.73.zip

# Install unzip and extract the Scap Security Guide
sudo apt install -y unzip
unzip scap-security-guide-0.1.73.zip

echo "Scap Security Guide downloaded"

# Copy the playbook to work_folder
cp ubuntu2204-playbook-cis_level1_workstation.yml ~/work_folder

# Add 'become: yes' to the playbook file for sudo privileges
sed -i '/^hosts:/a become: yes' ~/work_folder/ubuntu2204-playbook-cis_level1_workstation.yml

# Update the 'log_file_line' line in the playbook
sed -i "s/^log_file_line:.*/log_file_line: '{{ log_file_exists.stdout.split('' '') | last }}'/" ~/work_folder/ubuntu2204-playbook-cis_level1_workstation.yml

echo "log_file_line' modified"

# Create the my_hosts file and add the remote IP address
echo -e "[servers]\nserver1 ansible_host=$REMOTE_IP_ADDRESS" > ~/work_folder/my_hosts

# Create the ansible.cfg file with the specified configuration
cat <<EOL > ~/work_folder/ansible.cfg
[defaults]
inventory = ~/work_folder/my_hosts
private_key_file = ~/work_folder/id_rsa
remote_user = student
callbacks_enabled = log_plays
log_path = ansible_log_file.txt
EOL
