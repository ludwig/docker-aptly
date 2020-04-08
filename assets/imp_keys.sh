#! /usr/bin/env bash

# Copyright 2018-2020 Artem B. Smirnov
# Copyright 2018 Jon Azpiazu
# Copyright 2016 Bryan J. Hong
# Licensed under the Apache License, Version 2.0

Use: imp_keys.sh <path-to-keyring.gpg>

# Import keyrings if they exist
if [[ -f ${1} ]]; then
  gpg --list-keys
  gpg --no-default-keyring          \
      --keyring ${1}                \
      --export |                    \
  gpg --no-default-keyring          \
      --keyring trustedkeys.gpg     \
      --import
fi
