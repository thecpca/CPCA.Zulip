#!/bin/bash
set -e

# NOTE: This is only needed if you are using the bind mount for App_Data _AND_ you are
# running on the rs01.thecpca.ca Synology NAS. On another NAS the UID might be different,
# and on a non-Synology system you might not have to do this at all.

ZULIP="/volume1/docker/cpca_zulip/zulip"
REDIS="/volume1/docker/cpca_zulip/redis"
RABBITMQ="/volume1/docker/cpca_zulip/rabbitmq"
CONTAINER="cpca-zulip"
SUID=1654
SGID=1654

echo "==> Ensuring ZULIP, REDIS, and RABBITMQ directories exist"
for dir in "$ZULIP" "$REDIS" "$RABBITMQ"; then
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
    fi
done

echo "==> Removing Synology ACLs"
sudo synoacltool -del "$ZULIP" || true
sudo synoacltool -del "$REDIS" || true
sudo synoacltool -del "$RABBITMQ" || true

echo "==> Setting POSIX ownership"
sudo chown -R $SUID:$SGID "$ZULIP"
sudo chown -R $SUID:$SGID "$REDIS"
sudo chown -R $SUID:$SGID "$RABBITMQ"

echo "==> Setting permissions"
sudo chmod -R 775 "$ZULIP"
sudo chmod -R 775 "$REDIS"
sudo chmod -R 775 "$RABBITMQ"

echo "==> Starting container"
docker compose up -d

echo "==> Tailing logs"
docker compose logs -f $CONTAINER
