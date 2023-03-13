FROM node:16-slim AS base

RUN apt-get update && apt-get install -y \
    wget \
    git && rm -rf /var/lib/apt/lists/* && wget https://github.com/gohugoio/hugo/releases/download/v0.111.3/hugo_extended_0.111.3_linux-amd64.deb && dpkg -i hugo_extended_0.111.3_linux-amd64.deb

FROM base AS hugo

COPY /hugo /documentation
RUN chmod -R 777 /documentation && rm -f /documentation/.hugo_build.lock

FROM base AS excalidraw

RUN git clone -b v0.14.2 https://github.com/excalidraw/excalidraw.git excalidraw
RUN cd excalidraw && yarn && npx browserslist@latest --update-db
RUN mkdir -p /excalidraw/node_modules/.cache && chmod -R 777 /excalidraw/node_modules/.cache

FROM node:16-slim AS production

RUN mkdir -p /.yarn && touch /.yarnrc && mkdir -p /.cache && chmod -R 777 /.yarn /.yarnrc /.cache
COPY --from=hugo /documentation /documentation
COPY --from=hugo /usr/local/bin/hugo /usr/local/bin/hugo
COPY --from=excalidraw /excalidraw /excalidraw
RUN chmod -R 777 /documentation /excalidraw/node_modules/.cache
COPY start-documentation.sh start-documentation.sh

FROM production AS french

COPY /documents/fr/archetypes /documentation/archetypes
COPY /documents/fr/content /documentation/content-init
RUN chmod -R 777 /documentation/archetypes /documentation/content-init
EXPOSE 1313
CMD ./start-documentation.sh

FROM production AS english

COPY /documents/en/archetypes /documentation/archetypes
COPY /documents/en/content /documentation/content-init
RUN chmod -R 777 /documentation/archetypes /documentation/content-init
EXPOSE 1313
CMD ./start-documentation.sh
