#!/bin/bash

read -p 'Quel est le titre de la documention ? (repondre a pour annuler) : ' TITLE

if [ "$TITLE" = "a" ]; then
    #Votre code, par exemple:
    echo "Annulation de la création d'un nouveau document."
    exit
else
    echo "Création du document $TITLE"
    SLUG=$(echo "$TITLE" | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z | iconv -f utf8 -t ascii//TRANSLIT)
    hugo new docs/$SLUG.md
    exit
fi
