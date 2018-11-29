#!/usr/bin/env bash

actual_output() {
	printf "actual output:\n%s\n\n" "${output}"
}

actual_lines() {
	echo "actual # of lines: " ${#lines[@]}
}

actual_results() {
	actual_output
	actual_lines
}