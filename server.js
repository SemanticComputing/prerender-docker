#!/usr/bin/env node
var prerender = require('./lib');

var server = prerender({
    chromeLocation: '/usr/bin/google-chrome',
    chromeFlags: ['--headless', '--disable-gpu', '--remote-debugging-port=9222', '--hide-scrollbars', '--no-sandbox'],
    followRedirects: true,
    pageLoadTimeout: 1200
});

server.use(prerender.sendPrerenderHeader());
// server.use(prerender.blockResources());
server.use(prerender.removeScriptTags());
server.use(prerender.httpHeaders());

server.start();
