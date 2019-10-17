
include Makefile.lint
include Makefile.build_args

.PHONY: demo tests
GOSS_VERSION := 0.3.6

all: | pull build

pull:
	docker pull bearstech/java:latest

build:
	 docker build \
		$(DOCKER_BUILD_ARGS) \
		-t bearstech/neo4j:3 \
		.
	docker tag bearstech/neo4j:3 bearstech/neo4j:latest

push:
	docker push bearstech/neo4j:3
	docker push bearstech/neo4j:latest

tests: bin/goss bin/wait-for
	make -C tests tests

demo:
	cd demo && docker-compose up

bin:
	mkdir -p bin

bin/goss: bin
	curl -o bin/goss -L https://github.com/aelsabbahy/goss/releases/download/v${GOSS_VERSION}/goss-linux-amd64
	chmod +x bin/goss

bin/wait-for: bin
	curl -o bin/wait-for https://raw.githubusercontent.com/factorysh/wait-for/master/wait-for
	chmod +x bin/wait-for

clean:
	rm -rf demo/data bin tests/data

down:
	cd demo && docker-compose down
