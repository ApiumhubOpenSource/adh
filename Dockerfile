FROM node:10.14-jessie-slim
RUN apt-get update && apt-get -y install curl git
RUN curl -sSL https://get.docker.com/ | sh

# BASH Automated Testing  System
RUN git clone https://github.com/sstephenson/bats.git && \
    cd bats && ./install.sh /usr/local

RUN mkdir -p /adh
WORKDIR /adh

COPY package.json .
COPY package-lock.json .
RUN npm install

COPY src ./src
COPY tsconfig.json .
RUN npm run tsc

RUN ln -s /adh/dist/src/index.js /usr/bin/adh
RUN chmod 777 /usr/bin/adh

COPY test/*.sh ./
COPY test/*.bats ./
