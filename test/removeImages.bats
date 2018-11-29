#!/usr/bin/env bats
. ./utils.sh --source-only

setup () {
	echo "setup --"
	docker stop $(docker ps -aq) || true
	docker rm $(docker ps -aq) || true
	printf "FROM registry:2\nRUN mkdir test\n" > Dockerfile && docker build .
	echo "setup end --"
}

@test "adh remove none images" {
	run docker images --filter 'dangling=true'
	actual_results
	[ "${#lines[@]}" != "1" ]

	adh remove-none-images
	run docker images --filter 'dangling=true'
	actual_results
	[ "${#lines[@]}" = "1" ]
}

@test "adh remove images" {
	docker pull nginx
	docker pull registry:2
	run docker images
	actual_results
	[ "${#lines[@]}" != "1" ]

	adh remove-images
	run docker images
	actual_results
	[ "${#lines[@]}" = "1" ]
}
