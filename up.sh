#!/bin/sh

export IMAGE_TAG=$(git log -1 --pretty=format:%H main)

docker-compose -f docker-compose.example.yml up -d
