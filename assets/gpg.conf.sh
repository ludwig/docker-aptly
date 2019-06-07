#! /usr/bin/env bash

# Copyright 2018-2019 Artem B. Smirnov
# Copyright 2018 Jon Azpiazu
# Licensed under the Apache License, Version 2.0

mkdir -p  /root/.gnupg/
touch /root/.gnupg/gpg.conf
cat >> /root/.gnupg/gpg.conf <<EOF
personal-digest-preferences SHA256
cert-digest-algo SHA256
default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed
EOF
