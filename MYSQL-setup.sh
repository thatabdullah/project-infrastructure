#!/bin/sh

sudo apt-get update -yy
sudo apt-get install -yy git curl

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh

docker run -d -p 3306:3306 --env MYSQL_DATABASE=mydatabase --env MYSQL_PASSWORD=password --env MYSQL_USER=user --env MYSQL_ALLOW_EMPTY_PASSWORD=yes --name mysql mysql

