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

start: start-onlyoffice

stop: stop-onlyoffice

reset: reset-onlyoffice

clean: reset-onlyoffice reset-euro-office
