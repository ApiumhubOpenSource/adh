#!/usr/bin/env bash
set -e

echo "STARTING DOCKER SERVICE..."
service docker start &>/dev/null
echo "DOCKER SERVICE STARTED, PROCEEDING TO RUN TESTS"

for test in *.bats; do
	echo "RUNNING TEST $test"
	bats --tap $test
done

echo "TESTS IN GREEN, EVERYTHING IS FINE"