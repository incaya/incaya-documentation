#!/bin/bash

read -p "Quel est le titre de l'ADR ? (repondre a pour annuler) : " TITLE

if [ "$TITLE" = "a" ]; then
    #Votre code, par exemple:
    echo "Annulation de la création d'un nouveau ADR."
    exit
else
    echo "Création de l'ADR $TITLE"
    SLUG=$(echo "$TITLE" | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z | iconv -f utf8 -t ascii//TRANSLIT)
    hugo new adrs/$SLUG.md
    exit
fi
