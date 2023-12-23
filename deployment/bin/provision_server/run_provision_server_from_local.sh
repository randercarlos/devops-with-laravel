#!/bin/bash
set -ex
SSH_CONNECTION=$1
PUBLIC_KEY=$(ssh-keygen -y -f $HOME/.ssh/id_rsa)
PRIVATE_KEY=$HOME/.ssh/id_rsa
scp -C -o StrictHostKeyChecking=no -i $PRIVATE_KEY $HOME/.ssh/id_rsa $SSH_CONNECTION:~/.ssh/id_rsa
scp -C -o StrictHostKeyChecking=no -i $PRIVATE_KEY ./provision_server.sh $SSH_CONNECTION:./provision_server.sh
ssh -tt -o StrictHostKeyChecking=no -i $PRIVATE_KEY $SSH_CONNECTION "chmod +x ./provision_server.sh && ./provision_server.sh \"$PUBLIC_KEY\""
