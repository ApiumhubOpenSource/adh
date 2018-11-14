.PHONY: build

build: kill
	docker build -t adh:latest .
	docker run --privileged --name adhtest adh:latest bash /test/runTest.sh

kill:
	docker rm adhtest || true