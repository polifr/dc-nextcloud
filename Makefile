.PHONY: init-environment

init-environment:
	@if [ -f .env ]; then \
		echo "Il file .env esiste già: non verrà modificato."; \
	else \
		set -eu; \
		umask 077; \
		cp .env.example .env; \
		sed -i \
			-e "s/^TALK_SIGNALING_SECRET=GENERATE_ME$$/TALK_SIGNALING_SECRET=$$(openssl rand -hex 32)/" \
			-e "s/^TALK_TURN_SECRET=GENERATE_ME$$/TALK_TURN_SECRET=$$(openssl rand -hex 32)/" \
			-e "s/^TALK_INTERNAL_SECRET=GENERATE_ME$$/TALK_INTERNAL_SECRET=$$(openssl rand -hex 32)/" \
			.env; \
		echo "Creato .env con segreti Talk generati."; \
		echo "Completa le password CHANGE_ME prima di avviare i servizi."; \
	fi

update:
	docker pull postgres:18
	docker pull redis:8-alpine
	docker pull nextcloud:35
	docker pull nginx:1.31-alpine-slim
	docker pull ghcr.io/euro-office/documentserver:v9.3.7
	docker pull onlyoffice/documentserver:10.0
	docker pull collabora/code:26.04.5.2.1
	docker pull ghcr.io/nextcloud-releases/aio-talk:latest
	docker image prune -f

start-onlyoffice:
	OFFICE_TYPE=onlyoffice docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-onlyoffice.yaml \
		up -d --build --wait

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
		up -d --build --wait

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
		up -d --build --wait

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

create-certificates:
	mkdir -p nc-nginx/certs
	openssl req \
	    -x509 \
	    -newkey rsa:2048 \
	    -sha256 \
	    -days 825 \
	    -nodes \
	    -keyout nc-nginx/certs/nextcloud.local.key \
	    -out nc-nginx/certs/nextcloud.local.crt \
	    -subj "/CN=nextcloud.local" \
	    -addext "subjectAltName=DNS:nextcloud.local" \
	    -addext "basicConstraints=critical,CA:FALSE" \
	    -addext "keyUsage=digitalSignature,keyEncipherment" \
	    -addext "extendedKeyUsage=serverAuth"
