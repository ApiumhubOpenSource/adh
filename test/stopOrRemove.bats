#!/usr/bin/env bats
. ./utils.sh --source-only

setup () {
	echo "setup"
	docker stop $(docker ps -aq) || true
	docker rm $(docker ps -aq) || true
#	docker system prune -af
}

teardown () {
	echo "teardown"
}

@test "adh kill-containers stops all the containers" {
	docker run -d registry:2
	run adh ps
	actual_results
	[ "${#lines[@]}" = "6" ]
	adh kc
	run adh ps
	actual_results
	[ "${#lines[@]}" = "5" ]

	run adh psa
	actual_results
	[ "${#lines[@]}" = "6" ]
}

@test "adh stop -a stops all the containers" { #TODO: test stop a single container, not all at the same time
	docker run -d registry:2
	run adh ps
	actual_results
	[ "${#lines[@]}" = "6" ]
	adh stop -a
	run adh ps
	actual_results
	[ "${#lines[@]}" = "5" ]

	run adh psa
	actual_results
	[ "${#lines[@]}" = "6" ]
}

@test "adh stop selecting an option stops just that container" { #TODO: test stop a single container, not all at the same time
	docker run -d registry:2
	docker run -d nginx
	run adh ps
	actual_results
	[ "${#lines[@]}" = "7" ]

	echo " " | adh stop # this simulates pressing space to select the first option and pressing enter
	run adh ps
	actual_results
	[ "${#lines[@]}" = "6" ]

	run adh psa
	actual_results
	[ "${#lines[@]}" = "7" ]
}

@test "adh remove-containers removes all the containers started or stopped" {
	docker run -d registry:2
	adh stop -a
	docker run -d nginx
	run adh ps
	actual_results
	[ "${#lines[@]}" = "6" ]
	run adh psa
	actual_results
	[ "${#lines[@]}" = "7" ]
	adh rc
	run adh psa
	actual_results
	[ "${#lines[@]}" = "5" ]
}

@test "adh remove-exited-containers removes only stopped containers" {
	docker run -d registry:2
	adh stop -a
	docker run -d nginx
	run adh ps
	actual_results
	[ "${#lines[@]}" = "6" ]
	run adh psa
	actual_results
	[ "${#lines[@]}" = "7" ]
	adh remove-exited-containers
	run adh ps
	actual_results
	[ "${#lines[@]}" = "6" ]
	run adh psa
	actual_results
	[ "${#lines[@]}" = "6" ]
	[[ "${lines[3]}" =~ "nginx" ]]

}