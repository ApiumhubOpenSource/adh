#!/usr/bin/env bats
. ./utils.sh --source-only

setup () {
	echo "setup --"
	docker stop $(docker ps -aq) || true
	docker rm $(docker ps -aq) || true
	echo "setup end --"
}

@test "adh kill-containers stops all the containers" {
	docker run -d registry:2
	run docker ps
	actual_results
	assert_number_of_containers 1

	adh kc
	run docker ps
	actual_results
	assert_there_are_no_results

	run docker ps -a
	actual_results
	assert_number_of_containers 1
}

@test "adh stop -a stops all the containers" {
	docker run -d registry:2
	run docker ps
	actual_results
	assert_number_of_containers 1

	adh stop -a
	run docker ps
	actual_results
	assert_there_are_no_results

	run docker ps -a
	actual_results
	assert_number_of_containers 1
}

@test "adh stop selecting an option stops just that container" {
	docker run -d registry:2
	docker run -d nginx
	run docker ps
	actual_results
	assert_number_of_containers 2

	echo " " | adh stop # this simulates pressing space to select the first option and pressing enter
	run docker ps
	actual_results
	assert_number_of_containers 1

	run docker ps -a
	actual_results
	assert_number_of_containers 2
}

@test "adh stop when no containers running shows error" {
	run docker ps
	actual_results
	assert_number_of_containers 0

	run adh stop # this simulates pressing space to select the first option and pressing enter
	actual_results
	print_line 3
	assert_line_has_regex 3 "No containers running"
}

@test "adh remove-containers removes all the containers started or stopped" {
	docker run -d registry:2
	adh stop -a
	docker run -d nginx
	run docker ps
	actual_results
	assert_number_of_containers 1
	run docker ps -a
	actual_results
	assert_number_of_containers 2
	adh rc
	run docker ps -a
	actual_results
	assert_there_are_no_results
}

@test "adh remove-exited-containers removes only stopped containers" {
	docker run -d registry:2
	adh stop -a
	docker run -d nginx
	run docker ps
	actual_results
	assert_number_of_containers 1
	run docker ps -a
	actual_results
	assert_number_of_containers 2
	adh remove-exited-containers
	run docker ps
	actual_results
	assert_number_of_containers 1
	run docker ps -a
	actual_results
	assert_number_of_containers 1
	assert_container_has_regex 1 "nginx"
}