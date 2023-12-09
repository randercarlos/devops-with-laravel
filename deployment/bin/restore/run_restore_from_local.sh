#!/bin/bash

set -e

SSH_USER=$1
SSH_SERVER=$2
BACKUP_FILENAME=$3
MYSQL_USER=$4
MYSQL_PASSWORD=$5

scp -C -o StrictHostKeyChecking=no -i $HOME/.ssh/id_rsa $HOME/.ssh/id_rsa $SSH_USER@$SSH_SERVER:~/.ssh/id_rsa

scp -C -o StrictHostKeyChecking=no -i $HOME/.ssh/id_rsa ./restore.sh $SSH_USER@$SSH_SERVER:./restore.sh
ssh -tt -o StrictHostKeyChecking=no -i $HOME/.ssh/id_rsa $SSH_USER@$SSH_SERVER "chmod +x ./restore.sh && ./restore.sh $BACKUP_FILENAME $MYSQL_USER $MYSQL_PASSWORD"
