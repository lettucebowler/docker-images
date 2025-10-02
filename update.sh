#!/bin/bash
cd /opt/docker/volumes
ff=""
path="/opt/docker/stacks/*"
if [[ -n "$1" ]]; then
    path="/opt/docker/stacks/$1"
fi
for f in $path;
  do
    ff=${f##*/}
    echo Updating ${ff}
    docker compose -f $f/docker-compose.yml down
    docker compose -f $f/docker-compose.yml pull
    docker compose -f $f/docker-compose.yml up -d --remove-orphans
done
docker system prune -af