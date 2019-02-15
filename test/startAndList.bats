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


@test "adh start -a starts all the containers" {
	docker run --name registry -d registry:2
	docker run --name nginx -d nginx
	run docker ps
	actual_results
	assert_number_of_containers 2

	docker stop registry nginx
	run docker ps
	actual_results
	assert_there_are_no_results

	adh start -a
	run docker ps
	actual_results
	assert_number_of_containers 2
}


@test "adh start selecting an option starts just that container" {
	docker run --name registry -d registry:2
	docker run --name nginx -d nginx
	run docker ps
	actual_results
	assert_number_of_containers 2

	docker stop registry nginx
	run docker ps
	actual_results
	assert_there_are_no_results

	echo " " | adh start # this simulates pressing space to select the first option and pressing enter
	run docker ps
	actual_results
	assert_number_of_containers 1
}

@test "adh start with no stopped containers show an error" {
	docker run --name registry -d registry:2
	docker run --name nginx -d nginx
	run docker ps
	actual_results
	assert_number_of_containers 2

	run adh start
	actual_results
	print_line 3
	assert_line_has_regex 3 " No stopped containers"
}