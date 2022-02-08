# Incaya Documentation

Ce dépôt contient le code permettant de générer une image Docker contenant l'outillage de base que nous utilisons pour maintenir la documentation de nos projets, c'est-à-dire :

- [Hugo](https://gohugo.io/), un générateur statique de code, permettant d'afficher en HTML les fichiers de documentation écrits en `markdown`.
- Un [archetype](https://gohugo.io/content-management/archetypes/) Hugo permettant de générer des [ADRs](https://adr.github.io/).
- Des scripts permettant de générer facilement un document ou un ADR.
- Un thème basique basé sur [Hugo Whisper](https://github.com/zerostaticthemes/hugo-whisper-theme)
- Une instance d'[Excalidraw](https://github.com/excalidraw/excalidraw) pour réaliser nos schémas. 

![Le site de documentation vide](incaya-documentation.png)

## Principe de fonctionnement

**L'objectif principal d'`incaya-documentation` est de rendre facilement et rapidement accessible - à la lecture, mais aussi à l'écriture - la documentation de nos projets.**

À cette fin, cette documentation est réalisée en [markdown](https://docs.framasoft.org/fr/grav/markdown.html) dans un répertoire dédié de la base de code, proche du développeur donc. Ainsi, la documentation est directement accessible depuis Github par exemple. 

Mais pour la rendre encore plus facilement lisible, on va utiliser [Hugo](https://gohugo.io/) pour l'afficher directement dans l'environnement de développement. Hugo est un générateur de code statique qui va se charger d'afficher en HTML des fichiers `.md` contenus (et organisés) au sein d'un répertoire `content`. 

L'utilisation basique de l'image `incaya-documentation` va donc simplement consister à monter le répertoire stockant la documentation du projet dans un répertoire `content` du conteneur Docker.

Nous sommes aussi convaincus qu'une bonne documentation d'un projet informatique se doit d'inclure des schémas (d'architecture, d'infrastructure ...). Et nous aimons particulièrement la simplicité et l'efficacité d'[Excalidraw](https://github.com/excalidraw/excalidraw) pour réaliser de tel schéma. Il est donc inclus dans l'image Docker en plus de Hugo.

## Utilisation avec Docker

Soit un projet dont la documentation est contenue dans le répertoire `documentations` organisé de la manière suivante :

```bash
documentations
├── adrs
│   └── adr1.md
└── docs
    └── doc1.md
```

> La présence des répertoires `adrs` et `docs` correspond à notre organisation par défaut de la documentation, mais aussi aux menus générés par la configuration d'Hugo. Cela peut être modifié en surchargent cette configuration par défaut, voir la suite "Surchager la configuration"

On lance alors `incaya-documentation` de la maniére suivante :

```bash
docker run --rm --name project-documentation -d \
	-v documentations:/documentation/content \
	-p 3000:3000 \
	-p 1313:1313 \
	ghcr.io/incaya/incaya-documentation:latest
```

Hugo peut aussi utiliser des fichiers spécifiques pour gérer les pages d'accueil (accueil général, accueil documentation, accueil ADR). Vous pouvez générer ses fichiers en ligne de commande depuis le conteneur :

```bash
➜  docker exec -it project-documentation bash
root@27f70055675c:/# cd documentation/
root@27f70055675c:/documentation# ./init-doc.sh 
Le répertoire de documentation est bien présent.
La documentation est maintenant initialisée.
root@27f70055675c:/documentation# exit
```

Le site de documentation est alors visible sur http://localhost:1313

Excalidraw est accessible sur http://localhost:3000

## Utilisation avec Docker Compose

Bien évidement, la documentation peut être intégrée avec Docker Compose :

```yaml
version: "3.7"

services:
  documentation:
    image: ghcr.io/incaya/incaya-documentation:latest
    volumes:
      - ./documentations:/documentation/content
    ports:
      - 3000:3000
      - 1313:1313
```

Et voici une recette pouvant être ajoutées à un `Makefile` :

```makefile
# in Makefile
doc-init: # Setup documentation folder
	docker-compose run --rm --no-deps documentation bash -ci '\
		cd /documentation && \
		./init-doc.sh \
	'
```

## Générer des documents

Hugo utilise les [`front matter`](https://gohugo.io/content-management/front-matter/) présents dans les fichiers `.md`, entre autres la propriété `weight` pour gérer l'ordre des articles.

Il existe un script permettant de générer un nouveau fichier `md` de documentation avec le front matter prérempli : `new-docs.sh`. 

De la même manière, il existe un script permettant de créer un nouvel ADR : `new-docs.sh`.

Voici comment les intégrer dans un `Makefile` :

```makefile
# in Makefile
doc-new-adr: ## Create a new ADR
	docker-compose run --rm --no-deps documentation bash -ci '\
		cd /documentation && \
		./new-adr.sh \
	'
doc-new-doc: ## Create a new file for documentation
	docker-compose run --rm --no-deps documentation bash -ci '\
		cd /documentation && \
		./new-docs.sh \
	'
```

## Surchager la configuration

L'image Docker est fournie avec une configuration par défaut de Hugo. Cette configuration permet entre autres de définir les menus de site. Il est possible de remplacer cette configuration par défaut par une configuration propre au projet en cours, par exemple dans un fichier `hugo-config.toml` :

```toml
baseURL = "http://localhost"
languageCode = 'fr'
defaultContentLanguage = 'fr'
title = "Documentation Incaya"
theme = "hugo-whisper-theme"

pygmentsCodeFences = true
pygmentsCodefencesGuessSyntax = true
pygmentsUseClasses = true

# Controls how many words are printed in the content summary on the docs homepage.
# See https://gohugo.io/content-management/summaries/
summaryLength = 30

[[menu.main]]
    name = "Accueil"
    url = "/"
    weight = 1

[[menu.main]]
    name = "Documentation"
    url = "/docs/"
    weight = 2

[[menu.main]]
    name = "ADR."
    url = "/adrs/"
    weight = 3

[params]
  google_analytics_id=""
  homepage_button_link = '/docs'
  homepage_button_text = 'Lire la documentation'
  homepage_intro = 'Une introduction à mettre dans le contenu du fichier _index.md à la racine du répertoire de la documentation.'
  enable_anchor_link = true
  mainSections = ['docs', 'adrs']

  [params.homepage_meta_tags]
    meta_description = "Hugo Whisper is a documentation theme built with Hugo."
    meta_og_title = "Hugo Whisper Theme"
    meta_og_type = "website"
    meta_og_url = "https://hugo-whisper.netlify.app"
    meta_og_image = "https://raw.githubusercontent.com/JugglerX/hugo-whisper-theme/master/images/tn.png"
    meta_og_description = "Hugo Whisper is a documentation theme built with Hugo."
    meta_twitter_card = "summary"
    meta_twitter_site = "@zerostaticio"
    meta_twitter_creator = "@zerostaticio"
```

Il suffit alors de monter se fichier dans le conteneur Docker, par exemple avec Docker Compose :

```yaml
version: "3.7"

services:
  documentation:
    image: ghcr.io/incaya/incaya-documentation:latest
    volumes:
      - ./documentations:/documentation/content
      - ./hugo-config.toml:/documentation/config.toml
    ports:
      - 3000:3000
      - 1313:1313
```

## Publication

Si l'objectif principal est d'afficher la documentation en environnement de développement, rien n'empêche de profiter d'Hugo pour générer des fichiers statiques de la documentation, pour ensuite les héberger sur un service du type Github Pages ou Netlify.

Hugo générant les fichiers finaux dans un répertoire `public` :

```yaml
version: "3.7"

services:
  documentation:
    image: ghcr.io/incaya/incaya-documentation:latest
    volumes:
      - ./documentations:/documentation/content
      - ./doc-public:/documentation/public
      - ./hugo-config.toml:/documentation/config.toml
    ports:
      - 3000:3000
      - 1313:1313
```

```makefile
# in Makefile
doc-generate: ## Generate statics for documentation ready for publication
	docker-compose run --rm --no-deps documentation bash -ci '\
		cd /documentation && \
		hugo \
	'
```

## Reste à faire

- [ ] Gérer le poids des documents générés
- [ ] Mieux gérer le titre des documents générés
- [ ] Améliorer la page de liste des ADR

## Mainteneur

[![alexisjanvier](https://avatars1.githubusercontent.com/u/547706?s=96&v=4)](https://github.com/alexisjanvier)
[Alexis Janvier](https://github.com/alexisjanvier)

## License

incaya-documentation est sous licence [Apache](LICENSE), avec la permission [d'Incaya](https://www.incaya.fr).
