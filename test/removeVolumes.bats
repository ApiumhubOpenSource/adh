#!/usr/bin/env bats
setup () {
	echo "setup"
	docker stop $(docker ps -aq) || true
	docker rm $(docker ps -aq) || true
}

teardown () {
	echo "teardown"
}

@test "adh remove volumes" {
	mkdir /test
	docker volume create hello
	run docker volume ls
	echo "actual output: " ${output}
	echo "actual lines: " ${#lines[@]}
	[ "${#lines[@]}" = "2" ]

	adh remove-volumes
	run docker volume ls
	echo "actual output: " ${output}
	[ "${#lines[@]}" = "1" ]
}

