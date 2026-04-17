#!/bin/bash
set -e

# NOTE: This is only needed if you are using the bind mount for App_Data _AND_ you are
# running on the rs01.thecpca.ca Synology NAS. On another NAS the UID might be different,
# and on a non-Synology system you might not have to do this at all.

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"

source "$ROOT_DIR/start-common.sh"

DIRECTORIES=(
    "/volume1/docker/cpca-zulip/zulip"
    "/volume1/docker/cpca-zulip/redis"
    "/volume1/docker/cpca-zulip/rabbitmq"
)
CONTAINER="cpca-zulip"
SUID=1654
SGID=1654

start_bound_container "$SCRIPT_DIR"
