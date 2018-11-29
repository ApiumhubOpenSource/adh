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

	actual_results
	echo "actual lines 3: " ${lines[3]}

	[[ "${lines[3]}" =~ "local-registry" ]]
	[ "${#lines[@]}" = "6" ]
}

@test "adh nginx when no containers up" { # TODO: tests for nginx options
	adh nginx
	run adh ps
	[ "$status" -eq 0 ]

	actual_results
	echo "actual lines 3: " ${lines[3]}

	[[ "${lines[3]}" =~ "nginx" ]]
	[ "${#lines[@]}" = "6" ]
}
