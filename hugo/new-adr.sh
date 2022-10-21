#!/bin/bash

read -p "Quel est le titre de l'ADR ? (repondre a pour annuler) : " TITLE

if [ $TITLE = a ]; then
    echo "Annulation de la création d'un nouveau ADR."
    exit
else
    echo "Création de l'ADR $TITLE"
    SLUG=$(echo "$TITLE" | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z | iconv -f utf8 -t ascii//TRANSLIT)
    NB_FILES=$(find ./content/adrs -name "*.md" -type f | wc -l)
    # ((NB_FILES+=1))
    hugo new adrs/$SLUG.md
    sed -i -e "s/#SLUG/$SLUG/g" -e "s/#TITLE/$TITLE/g" -e "s/#WEIGHT/$NB_FILES/g" ./content/adrs/$SLUG.md
    chmod 777 ./content/adrs/$SLUG.md
    exit
fi
