FROM node:latest

EXPOSE 3000

ENV NODE_ENV production

WORKDIR /application

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable

RUN git clone --depth=1 --branch chrome https://github.com/prerender/prerender.git . \
    && npm install \
    && rm -rf /tmp/*

COPY server.js /application/

CMD ["node", "server.js"]
