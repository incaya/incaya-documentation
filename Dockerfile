FROM node:16-stretch as base

RUN wget https://github.com/gohugoio/hugo/releases/download/v0.92.1/hugo_extended_0.92.1_Linux-64bit.deb
RUN dpkg -i hugo_extended_0.92.1_Linux-64bit.deb
RUN hugo version
RUN npm i -g adr-tools
RUN git clone https://github.com/excalidraw/excalidraw.git excalidraw
RUN cd excalidraw && npm install

FROM base

WORKDIR /excalidraw
CMD ["npm", "run", "start"]
