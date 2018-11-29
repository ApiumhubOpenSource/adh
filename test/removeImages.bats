#!/usr/bin/env bats
. ./utils.sh --source-only

setup () {
	echo "setup"
	printf "FROM registry:2\nRUN mkdir test\n" > Dockerfile && docker build .
}

teardown () {
	echo "teardown"
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
