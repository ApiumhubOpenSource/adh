#!/usr/bin/env bash
set -e

echo "STARTING DOCKER SERVICE..."
service docker start

echo "DOCKER SERVICE STARTED"

for test in *.bats; do
	echo "RUNNING TEST $test"
	bats --tap $test
done
