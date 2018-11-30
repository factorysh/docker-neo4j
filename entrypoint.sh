#!/bin/bash

if [ "${PASSWORD:-nope}" == "nope" ]; then
    echo "PASSWORD env is mandatory" > /dev/stderr
    exit 1
fi
neo4j-admin set-initial-password $PASSWORD

echo "$@"
exec "$@"
