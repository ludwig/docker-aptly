#! /usr/bin/env bash

# Copyright 2018-2020 Artem B. Smirnov
# Licensed under the Apache License, Version 2.0

# Use: gen_htpasswd.sh <USER> <PASS>

# https://www.8host.com/blog/nastrojka-avtorizacii-na-osnove-parolya-na-nginx-v-ubuntu-14-04/
# https://nginx.org/ru/docs/http/ngx_http_auth_basic_module.html
# http://seriyps.ru/blog/2010/05/30/basic-http-avtorizaciya-dlya-nginx/
# https://www.aptly.info/doc/faq/

: ${USER:=${1}}
: ${PASS:=${2}}

[[ -z ${USER} ]] && { echo "User didn't specified"; exit 1; }
[[ -z ${PASS} ]] && { echo "Pass didn't specified"; exit 1; }

RECORD=$(echo -n "${USER}:" && echo "${PASS}" | openssl passwd -apr1 -stdin)

echo ${RECORD} | tee -a /opt/aptly/api.htpasswd \
    && echo "User & pass has added to /opt/aptly/api.htpasswd" \
    || echo "Something has gone wrong"
