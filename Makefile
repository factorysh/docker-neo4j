.PHONY: demo

all: | pull build

pull:
	docker pull bearstech/java:latest

build:
	docker build -t bearstech/neo4j:3 .
	docker tag bearstech/neo4j:3 bearstech/neo4j:latest

push:
	docker push bearstech/neo4j:3
	docker push bearstech/neo4j:latest

test:
	@echo 'ok'

demo:
	cd demo && docker-compose up

clean:
	rm -rf demo/data
