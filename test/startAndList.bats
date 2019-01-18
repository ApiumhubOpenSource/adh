#!/usr/bin/env bats
. ./utils.sh --source-only

setup () {
	echo "setup --"
	docker stop $(docker ps -aq) || true
	docker rm $(docker ps -aq) || true
	echo "setup end --"
}

@test "adh ps when no containers up" {
	run adh ps
	[ "${lines[0]}" = "┌───────────────────────────────────────────────────────────────────────────────────────────┐" ]
	[ "${lines[1]}" = "│                                                                                           │" ]
	[ "${lines[2]}" = "│   CONTAINER ID        NAMES               IMAGE               STATUS              PORTS   │" ]
	[ "${lines[3]}" = "│                                                                                           │" ]
	[ "${lines[4]}" = "└───────────────────────────────────────────────────────────────────────────────────────────┘" ]
	assert_status_ok
}

@test "adh psa when no containers up" {
	run adh psa
	[ "${lines[0]}" = "┌───────────────────────────────────────────────────────────────────────────────────────────┐" ]
	[ "${lines[1]}" = "│                                                                                           │" ]
	[ "${lines[2]}" = "│   CONTAINER ID        NAMES               IMAGE               STATUS              PORTS   │" ]
	[ "${lines[3]}" = "│                                                                                           │" ]
	[ "${lines[4]}" = "└───────────────────────────────────────────────────────────────────────────────────────────┘" ]
	assert_status_ok
}

@test "adh clr when no containers up" {
	adh clr
	run docker ps

	actual_results
	print_container 1

	assert_status_ok
	assert_container_has_regex 1 "local-registry"
	assert_number_of_containers 1
}

@test "adh nginx when no containers up" { # TODO: tests for nginx options
	adh nginx
	run docker ps

	actual_results
	print_container 1

	assert_status_ok
	assert_container_has_regex 1 "nginx"
	assert_number_of_containers 1
}
