#!/usr/bin/env bats

setup () {
	echo "setup"
	docker stop $(docker ps -aq) || true
	docker rm $(docker ps -aq) || true
#	docker system prune -af
}

teardown () {
	echo "teardown"
}

@test "adh ps when no containers up" {
	run adh ps
	[ "$status" -eq 0 ]

	[ "${lines[0]}" = "┌───────────────────────────────────────────────────────────────────────────────────────────┐" ]
	[ "${lines[1]}" = "│                                                                                           │" ]
	[ "${lines[2]}" = "│   CONTAINER ID        NAMES               IMAGE               STATUS              PORTS   │" ]
	[ "${lines[3]}" = "│                                                                                           │" ]
	[ "${lines[4]}" = "└───────────────────────────────────────────────────────────────────────────────────────────┘" ]
	[ "${#lines[@]}" = "5" ]
}

@test "adh psa when no containers up" {
	run adh psa
	[ "$status" -eq 0 ]

	[ "${lines[0]}" = "┌───────────────────────────────────────────────────────────────────────────────────────────┐" ]
	[ "${lines[1]}" = "│                                                                                           │" ]
	[ "${lines[2]}" = "│   CONTAINER ID        NAMES               IMAGE               STATUS              PORTS   │" ]
	[ "${lines[3]}" = "│                                                                                           │" ]
	[ "${lines[4]}" = "└───────────────────────────────────────────────────────────────────────────────────────────┘" ]
	[ "${#lines[@]}" = "5" ]
}

@test "adh clr when no containers up" {
	adh clr
	run adh ps
	[ "$status" -eq 0 ]

	echo "actual lines 3: " ${lines[3]}
	echo "actual lines: " ${#lines[@]}

	[[ "${lines[3]}" =~ "local-registry" ]]
	[ "${#lines[@]}" = "6" ]
}

@test "adh nginx when no containers up" { # TODO: tests for nginx options
	adh nginx
	run adh ps
	[ "$status" -eq 0 ]

	echo "actual lines 3: " ${lines[3]}
	echo "actual lines: " ${#lines[@]}

	[[ "${lines[3]}" =~ "nginx" ]]
	[ "${#lines[@]}" = "6" ]
}

@test "adh kill-containers stops all the containers" {
	docker run -d registry:2
	run adh ps
	echo "actual output: " ${output}
	[ "${#lines[@]}" = "6" ]
	adh kc
	run adh ps
	echo "actual output: " ${output}
	[ "${#lines[@]}" = "5" ]

	run adh psa
	echo "actual output: " ${output}
	[ "${#lines[@]}" = "6" ]
}

@test "adh stop -a stops all the containers" { #TODO: test stop a single container, not all at the same time
	docker run -d registry:2
	run adh ps
	echo "actual output: " ${output}
	[ "${#lines[@]}" = "6" ]
	adh stop -a
	run adh ps
	echo "actual output: " ${output}
	[ "${#lines[@]}" = "5" ]

	run adh psa
	echo "actual output: " ${output}
	[ "${#lines[@]}" = "6" ]
}

@test "adh remove-containers removes all the containers started or stopped" {
	docker run -d registry:2
	adh stop -a
	docker run -d nginx
	run adh ps
	echo "actual output: " ${output}
	[ "${#lines[@]}" = "6" ]
	run adh psa
	echo "actual output: " ${output}
	[ "${#lines[@]}" = "7" ]
	adh rc
	run adh psa
	echo "actual output: " ${output}
	[ "${#lines[@]}" = "5" ]
}

@test "adh remove-exited-containers removes only stopped containers" {
	docker run -d registry:2
	adh stop -a
	docker run -d nginx
	run adh ps
	echo "actual output: " ${output}
	[ "${#lines[@]}" = "6" ]
	run adh psa
	echo "actual output: " ${output}
	[ "${#lines[@]}" = "7" ]
	adh remove-exited-containers
	run adh ps
	echo "actual output: " ${output}
	[ "${#lines[@]}" = "6" ]
	run adh psa
	echo "actual output: " ${output}
	[ "${#lines[@]}" = "6" ]
	[[ "${lines[3]}" =~ "nginx" ]]

}