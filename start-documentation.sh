#!/bin/bash

# Start Excalidraw
cd /excalidraw && yarn start &

# Setup hugo configuration if not exist (aka nod mounted in the docker container)
cp -n /documentation/config-default.toml /documentation/config.toml
# Start hugo
cd /documentation && hugo server --bind 0.0.0.0 --navigateToChanged

# &

# # Wait for any process to exit
# wait -n

# # Exit with status of process that exited first
# exit $?
