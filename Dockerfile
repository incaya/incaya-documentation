FROM node:16-stretch

RUN wget https://github.com/gohugoio/hugo/releases/download/v0.92.1/hugo_extended_0.92.1_Linux-64bit.deb
RUN dpkg -i hugo_extended_0.92.1_Linux-64bit.deb
COPY /default-documentation /documentation
RUN git clone https://github.com/excalidraw/excalidraw.git excalidraw
RUN cd excalidraw && yarn

EXPOSE 1313
COPY start-documentation.sh start-documentation.sh
CMD ./start-documentation.sh
