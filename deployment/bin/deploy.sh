#!/bin/bash

set -e

cd /usr/src

sudo docker-compose -f docker-compose.prod.yml down --remove-orphans
sudo docker-compose -f docker-compose.prod.yml up -d

sudo docker-compose -f docker-compose.prod.yml exec -T api php artisan migrate --force
sudo docker-compose -f docker-compose.prod.yml exec -T api php artisan db:seed --force
sudo docker-compose -f docker-compose.prod.yml exec -T api php artisan config:cache
sudo docker-compose -f docker-compose.prod.yml exec -T api php artisan route:cache
sudo docker-compose -f docker-compose.prod.yml exec -T api php artisan view:cache
sudo docker-compose -f docker-compose.prod.yml exec -T api php artisan event:cache