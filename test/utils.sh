#!/usr/bin/env bash

actual_output() {
	printf "actual output:\n%s\n\n" "${output}"
}

actual_lines() {
	echo "actual # of lines: " ${#lines[@]}
}

actual_containers() {
	echo "actual # of containers: " $((${#lines[@]} - 1))
}

print_container() {
	echo "container line $(($1)): " ${lines[$(($1))]}
}

actual_results() {
	actual_output
	actual_lines
	actual_containers
}
assert_number_of_containers() {
	[[ "${#lines[@]}" = $(($1 + 1)) ]]
}
assert_number_of_results() {
	[[ "${#lines[@]}" = $(($1 + 1)) ]]
}
assert_there_are_results() {
	[ "${#lines[@]}" != "1" ]
}
assert_there_are_no_results() {
	[ "${#lines[@]}" = "1" ]
}
assert_container_has_regex() {
	[[ "${lines[$1]}" =~ "$2" ]]
}
assert_status_ok() {
	[ "$status" -eq 0 ]
}
assert_status_not_ok() {
	[ "$status" -eq 1 ]
}