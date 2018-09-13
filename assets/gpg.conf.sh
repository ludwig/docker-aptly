#!/bin/bash
mkdir -p  ~/.gnupg/
touch ~/.gnupg/gpg.conf
cat >> ~/.gnupg/gpg.conf <<EOF
personal-digest-preferences SHA256
cert-digest-algo SHA256
default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed
EOF
