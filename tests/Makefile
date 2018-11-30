tests:
	docker-compose up -d neo4j
	sleep 10
	docker-compose up  --abort-on-container-exit --exit-code-from client client
	docker-compose down || true
