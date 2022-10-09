FROM node:16-slim AS base

RUN apt-get update && apt-get install -y \
    wget \
    git && rm -rf /var/lib/apt/lists/* && wget https://github.com/gohugoio/hugo/releases/download/v0.104.3/hugo_extended_0.104.3_linux-amd64.deb && dpkg -i hugo_extended_0.104.3_linux-amd64.deb

FROM base AS hugo

COPY /default-documentation /documentation
RUN chmod -R 777 /documentation && rm -f /documentation/.hugo_build.lock

FROM base AS excalidraw

RUN git clone -b v0.12.0 https://github.com/excalidraw/excalidraw.git excalidraw
RUN cd excalidraw && yarn && npx browserslist@latest --update-db
RUN mkdir -p /excalidraw/node_modules/.cache && chmod -R 777 /excalidraw/node_modules/.cache

FROM base AS production

COPY --from=hugo /documentation /documentation
COPY --from=excalidraw /excalidraw /excalidraw
RUN chmod -R 777 /documentation /excalidraw/node_modules/.cache
EXPOSE 1313
COPY start-documentation.sh start-documentation.sh
CMD ./start-documentation.sh
