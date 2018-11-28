#!/usr/bin/env bats
setup () {
	echo "setup"
	printf "FROM registry:2\nRUN mkdir test\n" > Dockerfile && docker build .
}

teardown () {
	echo "teardown"
}

@test "adh remove none images" {
	run docker images --filter 'dangling=true'
	echo "actual output: " ${output}
	echo "actual lines: " ${#lines[@]}
	[ "${#lines[@]}" != "1" ]

	adh remove-none-images
	run docker images --filter 'dangling=true'
	echo "actual output: " ${output}
	[ "${#lines[@]}" = "1" ]
}

