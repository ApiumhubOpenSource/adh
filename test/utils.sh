#!/usr/bin/env bash

actual_output() {
	printf "actual output:\n%s\n\n" "${output}"
}

actual_lines() {
	echo "actual # of lines: " ${#lines[@]}
}

actual_containers() {
	echo "actual # of containers: " $((${#lines[@]} - 5))
}

print_container() {
	echo "actual lines 3: " ${lines[$(($1 + 2))]}
}

actual_results() {
	actual_output
	actual_lines
	actual_containers
}
assert_number_of_containers() {
	[[ "${#lines[@]}" = $(($1 + 5)) ]]
}
assert_container_has_regex() {
	[[ "${lines[$(($1 + 2))]}" =~ "$2" ]]
}
assert_status_ok() {
	[[ "$status" -eq 0 ]]
}