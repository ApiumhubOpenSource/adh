#!/usr/bin/env bats
. ./utils.sh --source-only

setup () {
	echo "setup --"
	docker stop $(docker ps -aq) || true
	docker rm $(docker ps -aq) || true
	echo "setup end --"
}

@test "adh remove volumes" {
	mkdir /test
	docker volume create hello
	run docker volume ls
	actual_results
	[ "${#lines[@]}" = "2" ]

	adh remove-volumes
	run docker volume ls
	actual_results
	[ "${#lines[@]}" = "1" ]
}

