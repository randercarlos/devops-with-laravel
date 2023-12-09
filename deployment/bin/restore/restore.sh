#!/bin/bash

set -e

BACKUP_FILENAME=$1
MYSQL_USER=$2
MYSQL_PASSWORD=$3

PROJECT_DIR="/usr/src"
BACKUP_DIR=$PROJECT_DIR"/usr/src/storage/app/backup"

cd $PROJECT_DIR
sudo docker-compose -f docker-compose.prod.yml exec -T api aws s3 cp s3://devops-with-laravel-backups/$BACKUP_FILENAME $PROJECT_DIR"/storage/app/backup.zip"
sudo docker-compose -f docker-compose.prod.yml exec -T api unzip -o $PROJECT_DIR"/storage/app/backup.zip" -d $BACKUP_DIR

sudo docker-compose -f docker-compose.prod.yml exec -T api php $PROJECT_DIR"/artisan" down

# Restore database
sudo docker-compose -f docker-compose.prod.yml exec -T api mysql -u$MYSQL_USER -p$MYSQL_PASSWORD posts < $BACKUP_DIR"/db-dumps/mysql-posts.sql"

# Copy the current files
sudo docker-compose -f docker-compose.prod.yml exec -T api mv $PROJECT_DIR"/.env" $PROJECT_DIR"/.env_before_restore"
sudo docker-compose -f docker-compose.prod.yml exec -T api mv $PROJECT_DIR"/storage/app/public" $PROJECT_DIR"/storage/app/public_before_restore"

# Restore old files from backup
sudo docker-compose -f docker-compose.prod.yml exec -T api mv $BACKUP_DIR"/"$PROJECT_DIR"/.env" $PROJECT_DIR"/.env"
sudo docker-compose -f docker-compose.prod.yml exec -T api mv $BACKUP_DIR"/"$PROJECT_DIR"/storage/app/public" $PROJECT_DIR"/storage/app/public"

sudo docker-compose -f docker-compose.prod.yml exec -T api php $PROJECT_DIR"/artisan" storage:link
sudo docker-compose -f docker-compose.prod.yml exec -T api php $PROJECT_DIR"/artisan" optimize:clear

sudo docker-compose -f docker-compose.prod.yml exec -T api php $PROJECT_DIR"/artisan" up -d
