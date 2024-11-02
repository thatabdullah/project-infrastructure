#!/bin/sh

sudo apt-get update -yy
sudo apt-get install -yy git curl

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh

git clone https://github.com/thatabdullah/project.git
cd project
echo "REDIS_HOST=${redis_host}" > .env

