.PHONY: demo tests
GOSS_VERSION := 0.3.6
GIT_VERSION := $(shell git rev-parse HEAD)

all: | pull build

pull:
	docker pull bearstech/java:latest

build:
	docker build \
		--build-arg GIT_VERSION=${GIT_VERSION} \
		-t bearstech/neo4j:3 \
		.
	docker tag bearstech/neo4j:3 bearstech/neo4j:latest

push:
	docker push bearstech/neo4j:3
	docker push bearstech/neo4j:latest

tests: bin/goss
	make -C tests tests

demo:
	cd demo && docker-compose up

bin/goss:
	mkdir -p bin
	curl -o bin/goss -L https://github.com/aelsabbahy/goss/releases/download/v${GOSS_VERSION}/goss-linux-amd64
	chmod +x bin/goss

clean:
	rm -rf demo/data bin

down:
	cd demo && docker-compose down
