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
    echo Backing up ${ff}
    docker compose --file ${f}/docker-compose.yml down
    if test -f /opt/docker/backup/backups/$ff.tar.lz4; then
      rm /opt/docker/backup/backups/$ff.tar.lz4
    fi
    if test -d /opt/docker/volumes/$ff; then
      if test -f /opt/docker/backup/backups/$(hostname).$ff.tar.lz4; then
        rm /opt/docker/backup/backups/$(hostname).$ff.tar.lz4
      fi
      tar -cvf - -C /opt/docker/volumes/$ff . | lz4 - /opt/docker/backup/backups/$(hostname).$ff.tar.lz4
    fi
    docker compose -f $f/docker-compose.yml up -d --remove-orphans
done
# two loops because I don't want to leave the service down while the backup is being transferred over the network.
for f in $path;
  do
    ff=${f##*/}
    if test -d /opt/docker/volumes/$ff; then
      echo Moving /opt/docker/backup/backups/$(hostname).$ff.tar.lz4 to Backups share
      if test -f /mnt/truenas/backups/$(hostname).$ff.tar.lz4; then
        mv /mnt/truenas/backups/$(hostname).$ff.tar.lz4 /mnt/truenas/backups/old.$(hostname).$ff.tar.lz4
      fi
      scp -v /opt/docker/backup/backups/$(hostname).$ff.tar.lz4 /mnt/truenas/backups/
      rm /opt/docker/backup/backups/$(hostname).$ff.tar.lz4
      if test -f /mnt/truenas/backups/old.$(hostname).$ff.tar.lz4; then
        rm /mnt/truenas/backups/old.$(hostname).$ff.tar.lz4
      fi
    fi
done