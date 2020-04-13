#! /usr/bin/env bash

# Copyright 2018-2020 Artem B. Smirnov
# Copyright 2018 Jon Azpiazu
# Copyright 2016 Bryan J. Hong
# Licensed under the Apache License, Version 2.0

# Generate certificate if it need
# It reads variables ${FULL_NAME} ${EMAIL_ADDRESS} ${GPG_PASSPHRASE}
/opt/gen_keys.sh

# Import Ubuntu keyrings if they exist
/opt/imp_keys.sh /usr/share/keyrings/ubuntu-archive-keyring.gpg

# Import Debian keyrings if they exist
/opt/imp_keys.sh /usr/share/keyrings/debian-archive-keyring.gpg

# Start Supervisor (He calls nginx)
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
