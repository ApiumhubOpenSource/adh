#!/usr/bin/env bash
set -e

echo "STARTING DOCKER SERVICE..."
service docker start &>/dev/null
echo "DOCKER SERVICE STARTED, PROCEEDING TO RUN TESTS"

if [[ -z "$1" ]]
then
	for test in *.bats; do
		echo "RUNNING TEST $test"
		bats --tap $test
	done
else
	echo "RUNNING TEST $1"
	bats --tap $1
fi

echo "TESTS IN GREEN, EVERYTHING IS FINE"