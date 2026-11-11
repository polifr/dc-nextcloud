export POSTGRES_VERSION := 18
export REDIS_VERSION := 8-alpine
export OSIXIA_OPENLDAP_VERSION := 1.5.0
export NEXTCLOUD_VERSION := 35
export NGINX_VERSION := 1.31-alpine-slim
export EURO_OFFICE_DS_VERSION := v9.3.7-1
export ONLYOFFICE_DS_VERSION := 10.0
export COLLABORA_CODE_VERSION := 26.04.5.2.1
export AIO_TALK_VERSION := latest

.PHONY: init-environment

init-environment:
	@if [ -f .env ]; then \
		echo "Il file .env esiste già: non verrà modificato."; \
	else \
		set -eu; \
		umask 077; \
		cp .env.example .env; \
		sed -i \
			-e "s|^NEXTCLOUD_ZAP_TEST_PASSWORD=GENERATE_ME$$|NEXTCLOUD_ZAP_TEST_PASSWORD=$$(openssl rand -base64 24)|" \
			-e "s|^POSTGRES_PASSWORD=GENERATE_ME$$|POSTGRES_PASSWORD=$$(openssl rand -base64 24)|" \
			-e "s|^LDAP_ADMIN_PASSWORD=GENERATE_ME$$|LDAP_ADMIN_PASSWORD=$$(openssl rand -base64 24)|" \
			-e "s|^LDAP_READONLY_USER_PASSWORD=GENERATE_ME$$|LDAP_READONLY_USER_PASSWORD=$$(openssl rand -base64 24)|" \
			-e "s|^TALK_SIGNALING_SECRET=GENERATE_ME$$|TALK_SIGNALING_SECRET=$$(openssl rand -base64 24)|" \
			-e "s|^TALK_TURN_SECRET=GENERATE_ME$$|TALK_TURN_SECRET=$$(openssl rand -base64 24)|" \
			-e "s|^TALK_INTERNAL_SECRET=GENERATE_ME$$|TALK_INTERNAL_SECRET=$$(openssl rand -base64 24)|" \
			.env; \
		echo "Creato .env con password e segreti Talk generati."; \
		echo "Completa le password CHANGE_ME prima di avviare i servizi."; \
	fi

update:
	docker pull postgres:${POSTGRES_VERSION}
	docker pull redis:${REDIS_VERSION}
	docker pull osixia/openldap:${OSIXIA_OPENLDAP_VERSION}
	docker pull nextcloud:${NEXTCLOUD_VERSION}
	docker pull nginx:${NGINX_VERSION}
	docker pull ghcr.io/euro-office/documentserver:${EURO_OFFICE_DS_VERSION}
	docker pull onlyoffice/documentserver:${ONLYOFFICE_DS_VERSION}
	docker pull collabora/code:${COLLABORA_CODE_VERSION}
	docker pull ghcr.io/nextcloud-releases/aio-talk:${AIO_TALK_VERSION}
	docker image prune -f

start-onlyoffice:
	docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-onlyoffice.yaml \
		up -d --build --wait

stop-onlyoffice:
	docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-onlyoffice.yaml \
		stop

reset-onlyoffice:
	docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-onlyoffice.yaml \
		down -v

start-euro-office:
	docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-euro-office.yaml \
		up -d --build --wait

stop-euro-office:
	docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-euro-office.yaml \
		stop

reset-euro-office:
	docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-euro-office.yaml \
		down -v

start-collabora:
	docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-collabora.yaml \
		up -d --build --wait

stop-collabora:
	docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-collabora.yaml \
		stop

reset-collabora:
	docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-collabora.yaml \
		down -v

start-all:
	docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-collabora.yaml \
		-f docker-compose-euro-office.yaml \
		-f docker-compose-onlyoffice.yaml \
		up -d --build --wait

stop-all:
	docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-collabora.yaml \
		-f docker-compose-euro-office.yaml \
		-f docker-compose-onlyoffice.yaml \
		stop

reset-all:
	docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-collabora.yaml \
		-f docker-compose-euro-office.yaml \
		-f docker-compose-onlyoffice.yaml \
		down -v

start:
	docker compose \
		-f docker-compose-common.yaml \
		up -d --build --wait

stop:
	docker compose \
		-f docker-compose-common.yaml \
		stop

logs:
	docker compose \
		-f docker-compose-common.yaml \
		logs --no-color --timestamps

reset:
	docker compose \
		-f docker-compose-common.yaml \
		down -v

clean:
	docker compose \
		-f docker-compose-common.yaml \
		-f docker-compose-collabora.yaml \
		-f docker-compose-euro-office.yaml \
		-f docker-compose-onlyoffice.yaml \
		down -v

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
