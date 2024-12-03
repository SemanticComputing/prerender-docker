FROM node:latest

EXPOSE 3000

ENV NODE_ENV production

WORKDIR /application

# Prerender: commit https://github.com/prerender/prerender/commit/824911bea723500f08c6215258e0cd730925d670 seems to break running google chrome -> use previous commit

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/* \
    && git clone --branch master https://github.com/prerender/prerender.git . \
    && git reset --hard eeb732a662732598dccbefaece8d364ad2bb5434 \
    && npm install \
    && rm -rf /tmp/*

COPY server.js /application/

# prevent zombie processes (see https://github.com/prerender/prerender/issues/484)
ENV TINI_VERSION v0.18.0
RUN wget -O /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

CMD ["node", "server.js"]
