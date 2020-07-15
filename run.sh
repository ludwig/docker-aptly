#!/bin/bash

PORT=9999
IMAGE="ludwig/aptly:latest"

OPTS=(
    --name="aptly"
    --detach=true
    --log-driver=syslog
    --restart=always
    --publish "${PORT}:80"
    --volume aptly-data:/opt/aptly
)

set -x
docker run "${OPTS[@]}" "${IMAGE}" "$@"
