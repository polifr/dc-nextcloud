update:
	docker pull postgres:18
	docker pull redis:8
	docker pull nextcloud:34
	docker pull nginx:1.31
	docker pull ghcr.io/euro-office/documentserver:latest
	docker pull onlyoffice/documentserver:9.4
	docker pull collabora/code:latest
	docker image prune -f

start-onlyoffice:
	OFFICE_TYPE=onlyoffice docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-onlyoffice.yaml \
		up -d --wait

stop-onlyoffice:
	OFFICE_TYPE=onlyoffice docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-onlyoffice.yaml \
		down

reset-onlyoffice:
	OFFICE_TYPE=onlyoffice docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-onlyoffice.yaml \
		down -v

start-euro-office:
	OFFICE_TYPE=euro-office docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-euro-office.yaml \
		up -d --wait

stop-euro-office:
	OFFICE_TYPE=euro-office docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-euro-office.yaml \
		down

reset-euro-office:
	OFFICE_TYPE=euro-office docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-euro-office.yaml \
		down -v

start-collabora:
	OFFICE_TYPE=collabora docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-collabora.yaml \
		up -d --wait

stop-collabora:
	OFFICE_TYPE=collabora docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-collabora.yaml \
		down

reset-collabora:
	OFFICE_TYPE=collabora docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-collabora.yaml \
		down -v


start: start-onlyoffice

stop: stop-onlyoffice

reset: reset-onlyoffice

clean: reset-onlyoffice reset-euro-office reset-collabora
