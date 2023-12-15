#!/bin/bash

IMAGE_TAG=$1

cd /usr/src

sudo sed -i "/IMAGE_TAG/c\IMAGE_TAG=$IMAGE_TAG" /usr/src/.env

sudo docker-compose -f docker-compose.prod.yml down --remove-orphans
sudo docker-compose -f docker-compose.prod.yml up -d
