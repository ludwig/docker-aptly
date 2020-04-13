#! /usr/bin/env bash

# Copyright 2018-2020 Artem Smirnov <urpylka@gmail.com>
# Licensed under the Apache License, Version 2.0

# Start Supervisor when container starts (He calls nginx)
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf &
sleep 4

# Generate GPG keys
/opt/gen_keys.sh "Artem Smirnov" "urpylka@gmail.com" "password"

echo2() {
    # TEMPLATE: echo_stamp <TEXT> <COLOR> <LINE_BREAK>
    # More info there https://www.shellhacks.com/ru/bash-colors/

    TEXT=$1
    # TEXT="$(date '+[%Y-%m-%d %H:%M:%S]') ${TEXT}"

    TEXT="\e[1m$TEXT\e[0m" # BOLD

    case "$2" in
        GREEN) TEXT="\e[32m${TEXT}\e[0m";;
        RED)   TEXT="\e[31m${TEXT}\e[0m";;
        BLUE)  TEXT="\e[34m${TEXT}\e[0m";;
    esac

    [[ -z $3 ]] \
        && { echo -e ${TEXT}; } \
        || { echo -ne ${TEXT}; }
}

RESP1=`curl -I --max-time 2 http://localhost:80 2>/dev/null`

[[ ! -z ${RESP1} ]] \
    && { echo2 "Host is up" "GREEN"; } \
    || { echo2 "Error: Host is down" "RED"; exit 1; }


RESP2=`curl -I --max-time 2 http://localhost:80/aptly_repo_signing.key 2>/dev/null`

[[ $(echo ${RESP2} | grep "HTTP/1.1 200 OK") ]] \
    && { echo2 "File exists" "GREEN"; } \
    || { echo2 "Error: Bad response from the file" "RED"; exit 1; }

[[ $(echo ${RESP2} | grep Content-Length | awk -F ': ' '{print $2}') > 2000 ]] \
    && { echo2 "Filesize is ok" "GREEN"; } \
    || { echo2 "Error: Filesize is too small" "RED"; exit 1; }


RESP3=`curl http://localhost:8080/api/version 2>/dev/null`

[[ $(echo ${RESP3} | grep "Version") ]] \
    && { echo2 "Aptly is ${RESP3}" "GREEN"; } \
    || { echo2 "Failed to connect to Aptly API" "RED"; exit 1; }
