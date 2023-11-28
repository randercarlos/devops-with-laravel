#!/bin/bash

set -e

SSH_KEY=$1

useradd -G www-data,root,sudo,docker -u 1000 -d /home/martin martin
mkdir -p /home/martin/.ssh
touch /home/martin/.ssh/authorized_keys
chown -R martin:martin /home/martin
chown -R martin:martin /usr/src
chmod 700 /home/martin/.ssh
chmod 644 /home/martin/.ssh/authorized_keys
echo "$SSH_KEY" >> /home/martin/.ssh/authorized_keys

echo "martin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/martin

# Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.19.1/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
