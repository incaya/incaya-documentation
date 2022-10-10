#!/bin/bash

GLOBAL_FOLDER=./content
if [ -d "$GLOBAL_FOLDER" ]; then
    echo "The documentation folder is present."
else
    echo "The 'content' directory is not present. It must be mounted in the Docker container!"
    exit
fi

GLOBAL=./content/_index.md
if test -f "$GLOBAL"; then
    echo "The documentation is already initialized."
else
    cp -r content-init-en/* content/
    chmod -R 777 content
    echo "The documentation is now initialized."
fi
