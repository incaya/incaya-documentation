#!/bin/bash

# Start Excalidraw
cd /excalidraw && yarn start &
  
# Start the second process
cd /documentation && hugo server --bind 0.0.0.0 --navigateToChanged &
  
# Wait for any process to exit
wait -n
  
# Exit with status of process that exited first
exit $?
