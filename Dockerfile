FROM node:16-stretch

RUN wget https://github.com/gohugoio/hugo/releases/download/v0.102.1/hugo_extended_0.102.1_Linux-64bit.deb
RUN dpkg -i hugo_extended_0.102.1_Linux-64bit.deb
COPY /default-documentation /documentation
RUN rm -f /documentation/.hugo_build.lock
RUN git clone -b v0.12.0 https://github.com/excalidraw/excalidraw.git excalidraw
RUN cd excalidraw && yarn

EXPOSE 1313
COPY start-documentation.sh start-documentation.sh
CMD ./start-documentation.sh
