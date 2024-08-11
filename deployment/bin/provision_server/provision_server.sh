#!/bin/bash

set -e
SSH_KEY=$1

export PATH="/usr/sbin:$PATH"

# execute config_server.sh
./../config_server.sh

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