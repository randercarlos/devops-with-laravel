#!/bin/bash

set -e

S3_FULL_URI_BACKUP_FILENAME=$1
MYSQL_USER=$2
MYSQL_PASSWORD=$3

PROJECT_DIR="/usr/src"
BACKUP_DIR=$PROJECT_DIR"/storage/app/backup"

cd $PROJECT_DIR
sudo docker-compose -f docker-compose.prod.yml exec -T api aws s3 cp $S3_FULL_URI_BACKUP_FILENAME $PROJECT_DIR"/storage/app/backup.zip"
sudo docker-compose -f docker-compose.prod.yml exec -T api unzip -o $PROJECT_DIR"/storage/app/backup.zip" -d $BACKUP_DIR

sudo docker-compose -f docker-compose.prod.yml exec -T api php $PROJECT_DIR"/artisan" down

sudo docker cp devops-with-laravel-api-1:/usr/src/storage/app/backup/db-dumps/mysql-posts.sql ./mysql-posts.sql

# Restore database
sudo docker-compose -f docker-compose.prod.yml exec -T mysql sh -c "exec mysql -h localhost -u $MYSQL_USER -p$MYSQL_PASSWORD posts" < ./mysql-posts.sql

sudo docker-compose -f docker-compose.prod.yml exec -T mysql sh -c 'rm -f ./mysql-posts.sql'

sudo docker-compose -f docker-compose.prod.yml exec -T -u root api sh -c "chmod -R o+w /usr/src/"

# Copy the current files
sudo docker-compose -f docker-compose.prod.yml exec -T api sh -c "cp $PROJECT_DIR/.env $PROJECT_DIR/.env_before_restore"

sudo docker-compose -f docker-compose.prod.yml exec -T api cp -r $PROJECT_DIR"/storage/app/public" $PROJECT_DIR"/storage/app/public_before_restore"

# Restore old files from backup
sudo docker-compose -f docker-compose.prod.yml exec -T api cp $BACKUP_DIR"/"$PROJECT_DIR"/.env" $PROJECT_DIR"/.env"
sudo docker-compose -f docker-compose.prod.yml exec -T api cp -r $BACKUP_DIR"/"$PROJECT_DIR"/storage/app/public" $PROJECT_DIR"/storage/app/public"

sudo docker-compose -f docker-compose.prod.yml exec -T api php $PROJECT_DIR"/artisan" storage:link --force
sudo docker-compose -f docker-compose.prod.yml exec -T api php $PROJECT_DIR"/artisan" optimize:clear
sudo docker-compose -f docker-compose.prod.yml exec -T api php $PROJECT_DIR"/artisan" optimizer

sudo docker-compose -f docker-compose.prod.yml exec -T api php $PROJECT_DIR"/artisan" up
