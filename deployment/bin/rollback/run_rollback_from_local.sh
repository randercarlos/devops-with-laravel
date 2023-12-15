#!/bin/bash

set -e

SSH_USER=$1
SSH_SERVER=$2
IMAGE_TAG=$3

scp -C -o StrictHostKeyChecking=no -i $HOME/.ssh/id_rsa $HOME/.ssh/id_rsa $SSH_USER@$SSH_SERVER:~/.ssh/id_rsa

scp -C -o StrictHostKeyChecking=no -i $HOME/.ssh/id_rsa ./rollback.sh $SSH_USER@$SSH_SERVER:./rollback.sh
ssh -tt -o StrictHostKeyChecking=no -i $HOME/.ssh/id_rsa $SSH_USER@$SSH_SERVER "chmod +x ./rollback.sh && ./rollback.sh $IMAGE_TAG"
