#!/bin/bash

set -e

cd /usr/src


sudo docker image prune -f --filter "until=48h" # remove images old more 2 days or more. Free space. Optional
sudo docker-compose -f docker-compose.prod.yml down --remove-orphans
sudo docker-compose -f docker-compose.prod.yml up -d

sudo docker-compose -f docker-compose.prod.yml exec -T api php artisan optimize:clear
sudo docker-compose -f docker-compose.prod.yml exec -T api php artisan optimize
sudo docker-compose -f docker-compose.prod.yml exec -T api rm -f public/storage
sudo docker-compose -f docker-compose.prod.yml exec -T api php artisan storage:link
sudo docker-compose -f docker-compose.prod.yml exec -T api php artisan migrate --force
sudo docker-compose -f docker-compose.prod.yml exec -T api php artisan db:seed --force