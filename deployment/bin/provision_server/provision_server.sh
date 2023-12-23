#!/bin/bash

set -e
SSH_KEY=$1

export PATH="/usr/sbin:$PATH"

if ! id "apprunner" >/dev/null 2>&1; then
    sudo useradd -G www-data,root,sudo -u 2000 -d /home/apprunner apprunner
    sudo usermod -aG sudo apprunner
    sudo mkdir -p /home/apprunner/.ssh
    sudo touch /home/apprunner/.ssh/authorized_keys
    sudo chown -R apprunner:apprunner /home/apprunner
    sudo chown -R apprunner:apprunner /home/apprunner/.ssh
    sudo chown -R apprunner:apprunner /usr/src
    sudo chmod -R 700 /home/apprunner
    sudo chmod 644 /home/apprunner/.ssh/authorized_keys
    echo "$SSH_KEY" | sudo tee -a /home/apprunner/.ssh/authorized_keys >/dev/null
    sudo bash -c 'echo "apprunner ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/apprunner'
fi

# Install docker
sudo apt-get update -y
sudo apt-get install unzip -y
sudo curl -fsSL https://get.docker.com/ | sh
sudo usermod -aG docker apprunner
docker --version

# Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.19.1/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

# Install AWS CLI
sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip -o awscliv2.zip
sudo ./aws/install --update
sudo rm -f awscliv2.zip

PATH="/root/.local/bin:${PATH}"

# Definindo codigos de cor ANSI
verde='\033[0;32m'
reset='\033[0m'
echo -e "${verde}Provision was successfully executed!${reset}"