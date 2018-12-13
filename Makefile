.PHONY: build test bash kill

test: build
	docker run --privileged --name adhtest adh:latest bash testRunner.sh

build: kill
	docker build -t adh:latest .

bash: build
	docker run -it --privileged adh:latest bash

kill:
	docker rm adhtest || true