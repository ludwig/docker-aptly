#!/bin/bash
# Generates the GPG keypair in the volume `aptly-data`.

IMAGE=ludwig/aptly:latest

if [[ -z ${GPG_PASSPHRASE} ]]; then
    echo -n "Enter GPG passphrase: "
    read -s GPG_PASSPHRASE
    echo
fi

if [[ -z ${FULL_NAME} ]]; then
    echo -n "Enter your full name: "
    read FULL_NAME
fi

if [[ -z ${EMAIL_ADDRESS} ]]; then
    echo -n "Enter your email: "
    read EMAIL_ADDRESS
fi

OPTS=(
    --rm
    --log-driver=none
    --env "FULL_NAME=${FULL_NAME}"
    --env "EMAIL_ADDRESS=${EMAIL_ADDRESS}"
    --env "GPG_PASSPHRASE=${GPG_PASSPHRASE}"
    --volume aptly-data:/opt/aptly
)

docker run "${OPTS[@]}" "${IMAGE}" /opt/gen_keys.sh
