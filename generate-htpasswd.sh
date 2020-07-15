#!/bin/bash
# Generate htpasswd for the Aptly REST API

IMAGE=ludwig/aptly:latest

if [[ -z ${ADMIN_USER} ]]; then
    ADMIN_USER=admin
fi

if [[ -z ${ADMIN_PASS} ]]; then
    echo -n "Enter admin password: "
    read -s ADMIN_PASS
    echo
fi

OPTS=(
    --rm
    --log-driver=none
    --env "USER=${ADMIN_USER}"
    --env "PASS=${ADMIN_PASS}"
    --volume aptly-data:/opt/aptly
)

docker run "${OPTS[@]}" "${IMAGE}" /opt/gen_htpasswd.sh
