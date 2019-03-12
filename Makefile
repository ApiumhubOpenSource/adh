.PHONY: build test

test-and-copy-dist: test
	docker cp adhtest:/adh/dist .

test: build
	docker run --privileged --name adhtest adh:latest bash testRunner.sh

single-test: build
	docker run --privileged --name adhtest adh:latest bash testRunner.sh ${TEST}.bats

build: kill
	docker build -t adh:latest .

bash: build
	docker run -it --privileged adh:latest bash

kill:
	docker rm adhtest || true
