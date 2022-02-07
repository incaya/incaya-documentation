#!/bin/bash

GLOBAL_FOLDER=./content
if [ -d "$GLOBAL_FOLDER" ]; then
    echo "Le répertoire de documentation est bien présent."
else 
    echo "Le répertoire 'content' n'est pas présent. Il faut le monter dans le conteneur Docker !"
    exit
fi

GLOBAL=./content/_index.md
if test -f "$GLOBAL"; then
    echo "La documentation est bien initialisée."
else 
    cp -r content-init/* content/
    echo "La documentation est maintenant initialisée."
fi
