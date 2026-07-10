start:
	docker compose up -d --wait

stop:
	docker compose down

clean:
	docker compose down -v
