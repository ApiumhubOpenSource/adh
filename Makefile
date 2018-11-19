.PHONY: build

build: kill
	docker build -t adh:latest .
	docker run --privileged --name adhtest adh:latest bash testRunner.sh

kill:
	docker rm adhtest || true