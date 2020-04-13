#! /usr/bin/env bash

# Copyright 2018-2020 Artem Smirnov <urpylka@gmail.com>
# Licensed under the Apache License, Version 2.0

# Start Supervisor when container starts (He calls nginx)
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf &
sleep 4

# Generate GPG keys
/opt/gen_keys.sh "Artem Smirnov" "urpylka@gmail.com" "password"

RESP1=`curl -I --max-time 2 http://127.0.0.1 2>/dev/null`
[[ -z ${RESP1} ]] && { echo "Error: Host is down"; exit 1; } || { echo "Host is up"; }

RESP2=`curl -I --max-time 2 http://127.0.0.1/aptly_repo_signing.key 2>/dev/null`
[[ $(echo ${RESP2} | grep "HTTP/1.1 200 OK") ]] || { echo "Error: Bad response"; exit 1; } \
    && { echo "File exist"; }
[[ $(echo ${RESP2} | grep Content-Length | awk -F ': ' '{print $2}') > 2000 ]] \
    && { echo "Filesize is ok"; } || { echo "Error: Filesize is too small"; exit 1; }
