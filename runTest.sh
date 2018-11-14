#!/usr/bin/env bash
set -e

service docker start

echo "adh -h: ->"
node /test/dist/src/index.js -h

echo "docker ps: ->"
docker ps

echo "adh ps ->"
node /test/dist/src/index.js ps

echo "adh psa ->"
node /test/dist/src/index.js psa

echo "adh nginx ->"
node /test/dist/src/index.js nginx

echo "adh clr ->"
node /test/dist/src/index.js clr

echo "adh psa ->"
node /test/dist/src/index.js psa

node /test/dist/src/index.js stop -a

node /test/dist/src/index.js psa

node /test/dist/src/index.js rc

node /test/dist/src/index.js psa