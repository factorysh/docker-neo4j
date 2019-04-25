tests: test-decompose

data:
	mkdir -p data

test-decompose: data
	docker-compose up -d neo4j
	docker-compose up --exit-code-from client client
	docker-compose down || true

down:
	docker-compose down
