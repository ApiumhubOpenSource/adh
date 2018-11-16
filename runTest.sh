#!/usr/bin/env bash
set -e

service docker start

ln -s /adh/dist/src/index.js /usr/bin/adh
chmod 777 /usr/bin/adh
bats --tap tests.bats