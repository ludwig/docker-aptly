#!/bin/bash
# Create the `aptly-data` volume if it doesn't exist.

readonly volume=aptly-data
docker volume inspect -f '{{ .Mountpoint }}' "${volume}" >/dev/null 2>&1
if [[ $? -ne 0 ]]; then
    set -x
    docker volume create --name "${volume}"
fi
