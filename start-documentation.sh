#!/bin/bash
PORT="${HUGO_PORT:=1313}"
# Start Excalidraw
cd /excalidraw && yarn start &

# Setup hugo configuration if not exist (aka nod mounted in the docker container)
cp -n /documentation/config-default.toml /documentation/config.toml
# Start hugo
cd /documentation && hugo server --port $PORT --bind 0.0.0.0 --navigateToChanged
