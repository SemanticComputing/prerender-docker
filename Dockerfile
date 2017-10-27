FROM node:latest

EXPOSE 3000

ENV NODE_ENV production

WORKDIR /application

RUN git clone --depth=1 --branch master https://github.com/prerender/prerender.git . \
    && npm install \
    && rm -rf /tmp/*

CMD ["node", "server.js"]
