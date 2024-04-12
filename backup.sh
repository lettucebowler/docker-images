cd /opt/docker/volumes
ff=""
for f in /opt/docker/stacks/*;
  do
    ff=${f##*/}
    echo Backing up ${ff}
    echo ${f}/docker-compose.yml
    docker-compose --file ${f}/docker-compose.yml down
    if test -f /opt/docker/backup/backups/$ff.tar.lz4; then
      rm /opt/docker/backup/backups/$ff.tar.lz4
    fi
    tar -cvf - -C /opt/docker/volumes/$ff . | lz4 - /opt/docker/backup/backups/$ff.tar.lz4
    docker-compose -f $f/docker-compose.yml pull
    docker-compose -f $f/docker-compose.yml up -d --remove-orphans
done
for f in /opt/docker/stacks/*;
  do
    ff=${f##*/}
    echo Moving /opt/docker/backup/backups/$ff.tar.lz4 to Backups share
    cp /opt/docker/backup/backups/$ff.tar.lz4 /mnt/truenas/backups/$ff.tar.lz4
    rm /opt/docker/backup/backups/$ff.tar.lz4
done
docker system prune -af
