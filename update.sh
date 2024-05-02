cd /opt/docker/volumes
ff=""
for f in /opt/docker/stacks/*;
  do
    ff=${f##*/}
    echo Backing up ${ff}
    docker compose --file ${f}/docker-compose.yml down
    docker compose -f $f/docker-compose.yml pull
    docker compose -f $f/docker-compose.yml up -d --remove-orphans
done
docker system prune -af