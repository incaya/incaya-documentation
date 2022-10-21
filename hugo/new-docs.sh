#!/bin/bash

read -p 'Quel est le titre de la documention ? (repondre a pour annuler) : ' TITLE

if [ $TITLE = a ]; then
    echo "Annulation de la création d'un nouveau document."
    exit
else
    echo "Création du document $TITLE"
    SLUG=$(echo "$TITLE" | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z | iconv -f utf8 -t ascii//TRANSLIT)
    NB_FILES=$(find ./content/docs -name "*.md" -type f | wc -l)
    # ((NB_FILES+=1))
    hugo new docs/$SLUG.md
    sed -i -e "s/#SLUG/$SLUG/g" -e "s/#TITLE/$TITLE/g" -e "s/#WEIGHT/$NB_FILES/g" ./content/docs/$SLUG.md
    chmod 777 ./content/docs/$SLUG.md
    exit
fi
