FROM node:20

COPY ex-03-docker-inbound-agent/app/package.json .

WORKDIR /usr/src/app

RUN npm install

COPY ex-03-docker-inbound-agent/app .

EXPOSE 3000

CMD  ["node", "index.js"]