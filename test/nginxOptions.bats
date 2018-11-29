#!/usr/bin/env bats
. ./utils.sh --source-only

setup () {
	echo "setup --"
	docker stop $(docker ps -aq) || true
	docker rm $(docker ps -aq) || true
	echo "setup end --"
}

@test "adh nginx -p 9000 should map the port 80 to the 9000" {
	adh nginx -p 9000
	run adh psa
	actual_results
	echo "line 3: " ${lines[3]}
	[[ "${lines[3]}" =~ ":9000->80/tcp" ]]
}

@test "adh nginx -n this_is_a_test_name should start the container with the name this_is_a_test_name" {
	adh nginx -n this_is_a_test_name
	run adh psa
	actual_results
	echo "line 3: " ${lines[3]}
	[[ "${lines[3]}" =~ "this_is_a_test_name" ]]
}

@test "adh nginx should not create the new container in case of conflict with names" {
	adh nginx -n this_is_a_test_name -p 9000
	run adh psa
	actual_results
	echo "line 3: " ${lines[3]}
	[[ "${lines[3]}" =~ "this_is_a_test_name" ]]
	[[ "${lines[3]}" =~ ":9000->80/tcp" ]]

	adh nginx -n this_is_a_test_name -p 5555
	run adh psa
	actual_results
	echo "line 3: " ${lines[3]}
	[[ "${lines[3]}" =~ "this_is_a_test_name" ]]
	[[ "${lines[3]}" =~ ":9000->80/tcp" ]]
}

@test "adh nginx -f should remove nginx container with same name in case of conflict" {
	adh nginx -n this_is_a_test_name -p 9000
	run adh psa
	actual_results
	echo "line 3: " ${lines[3]}
	[[ "${lines[3]}" =~ "this_is_a_test_name" ]]
	[[ "${lines[3]}" =~ ":9000->80/tcp" ]]

	adh nginx -n this_is_a_test_name -f -p 5555
	run adh psa
	actual_results
	echo "line 3: " ${lines[3]}
	[[ "${lines[3]}" =~ "this_is_a_test_name" ]]
	[[ "${lines[3]}" =~ ":5555->80/tcp" ]]
}
