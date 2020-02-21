#!/bin/bash

set -e

container_root_ca=/root/.local/share/mkcert/rootCA.pem
container_root_ca_key=/root/.local/share/mkcert/rootCA-key.pem

host_root_ca=/host/ca-certificates/mkcert-traefik.crt
host_root_ca_key=/host/ca-certificates/mkcert-traefik-key.pem

if [ -f "$host_root_ca" ] && [ -f "$host_root_ca_key" ]
then
    mkdir -p "$(dirname "$container_root_ca")"
    cp "$host_root_ca" "$container_root_ca"
    cp "$host_root_ca_key" "$container_root_ca_key"
    mkcert -install
else
    mkcert -install
    mkdir -p "$(dirname "$host_root_ca")"
    cp "$container_root_ca" "$host_root_ca"
    cp "$container_root_ca_key" "$host_root_ca_key"
fi

if [[ "$HTTPS_DOMAINS" != '' ]]
then
    mkdir -p /var/ssl
    echo "$HTTPS_DOMAINS" | xargs mkcert --cert-file /var/ssl/mkcert.pem --key-file /var/ssl/mkcert-key.pem
fi
