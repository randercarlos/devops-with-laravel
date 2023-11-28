#!/bin/bash

set -ex

SSH_CONNECTION=$1
#NAME=$1
#SIZE=${2:-s-1vcpu-1gb}
#
#SSH_FINGERPRINT_DEPLOY=$(doctl compute ssh-key list --no-header | grep "devops-with-laravel-deploy" | awk '{ print $3 }')
#SSH_FINGERPRINT_OWN=$(doctl compute ssh-key list --no-header | grep "MacBook Air" | awk '{ print $4 }')



#OUTPUT=$(doctl compute droplet create --image docker-20-04 --size s-1vcpu-1gb --region nyc1 --ssh-keys $SSH_FINGERPRINT_DEPLOY --ssh-keys $SSH_FINGERPRINT_OWN --no-header $NAME)
#
#DROPLET_ID=$(echo $OUTPUT | awk '{ print $1 }')
#
#sleep 120
#
#doctl projects resources assign cad78098-bfb8-4861-bfb2-e969cee18f16 --resource=do:droplet:$DROPLET_ID
#
#sleep 10
#
#SERVER_IP=$(doctl compute droplet get $DROPLET_ID --format PublicIPv4 --no-header)

PUBLIC_KEY=$(cat $HOME/.ssh/id_rsa.pub)
PRIVATE_KEY=$HOME/.ssh/lightsail-private-key.pem

scp -C -o StrictHostKeyChecking=no -i $PRIVATE_KEY $HOME/.ssh/id_rsa $SSH_CONNECTION:~/.ssh/id_rsa
scp -C -o StrictHostKeyChecking=no -i $PRIVATE_KEY ./provision_server.sh $SSH_CONNECTION:./provision_server.sh
ssh -tt -o StrictHostKeyChecking=no -i $PRIVATE_KEY $SSH_CONNECTION "chmod +x ./provision_server.sh && ./provision_server.sh \"$PUBLIC_KEY\""
