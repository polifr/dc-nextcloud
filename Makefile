export POSTGRES_VERSION := 18
export REDIS_VERSION := 8-alpine
export OSIXIA_OPENLDAP_VERSION := 1.5.0
export NEXTCLOUD_VERSION := 35
export NGINX_VERSION := 1.31-alpine-slim
export EURO_OFFICE_DS_VERSION := v9.3.8
export ONLYOFFICE_DS_VERSION := 10.0
export COLLABORA_CODE_VERSION := 26.04.6.1.1
export AIO_TALK_VERSION := latest
export ZAP_PROXY_VERSION := 2.17.0

COMPOSE := docker compose -f docker-compose-common.yaml

ifneq ($(filter enable-zap,$(MAKECMDGOALS)),)
COMPOSE += -f docker-compose-zap.yaml
endif

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
			-e "s|^ZAP_API_KEY=GENERATE_ME$$|ZAP_API_KEY=$$(openssl rand -base64 24)|" \
			.env; \
		echo "Creato .env con password e secrets generati."; \
		echo "Completa le password CHANGE_ME prima di avviare i servizi."; \
	fi

.PHONY: enable-zap

enable-zap:
	@:

update:
	docker pull postgres:${POSTGRES_VERSION}
	docker pull redis:${REDIS_VERSION}
	docker pull osixia/openldap:${OSIXIA_OPENLDAP_VERSION}
	docker pull nextcloud:${NEXTCLOUD_VERSION}
	docker pull ghcr.io/nextcloud-releases/aio-talk:${AIO_TALK_VERSION}
	docker pull nginx:${NGINX_VERSION}
	docker pull zaproxy/zap-stable:${ZAP_PROXY_VERSION}
	docker pull ghcr.io/euro-office/documentserver:${EURO_OFFICE_DS_VERSION}
	docker pull onlyoffice/documentserver:${ONLYOFFICE_DS_VERSION}
	docker pull collabora/code:${COLLABORA_CODE_VERSION}
	docker image prune -f

start-onlyoffice:
	$(COMPOSE) \
		-f docker-compose-onlyoffice.yaml \
		up -d --build --wait

stop-onlyoffice:
	$(COMPOSE) \
		-f docker-compose-onlyoffice.yaml \
		stop

reset-onlyoffice:
	$(COMPOSE) \
		-f docker-compose-onlyoffice.yaml \
		down -v

start-euro-office:
	$(COMPOSE) \
		-f docker-compose-euro-office.yaml \
		up -d --build --wait

stop-euro-office:
	$(COMPOSE) \
		-f docker-compose-euro-office.yaml \
		stop

reset-euro-office:
	$(COMPOSE) \
		-f docker-compose-euro-office.yaml \
		down -v

start-collabora:
	$(COMPOSE) \
		-f docker-compose-collabora.yaml \
		up -d --build --wait

stop-collabora:
	$(COMPOSE) \
		-f docker-compose-collabora.yaml \
		stop

reset-collabora:
	$(COMPOSE) \
		-f docker-compose-collabora.yaml \
		down -v

start-all:
	$(COMPOSE) \
		-f docker-compose-collabora.yaml \
		-f docker-compose-euro-office.yaml \
		-f docker-compose-onlyoffice.yaml \
		up -d --build --wait

stop-all:
	$(COMPOSE) \
		-f docker-compose-collabora.yaml \
		-f docker-compose-euro-office.yaml \
		-f docker-compose-onlyoffice.yaml \
		stop

reset-all:
	$(COMPOSE) \
		-f docker-compose-collabora.yaml \
		-f docker-compose-euro-office.yaml \
		-f docker-compose-onlyoffice.yaml \
		down -v

start:
	$(COMPOSE) \
		up -d --build --wait

stop:
	$(COMPOSE) \
		stop

logs:
	$(COMPOSE) \
		logs --no-color --timestamps

reset:
	$(COMPOSE) \
		down -v

clean:
	$(COMPOSE) \
		-f docker-compose-collabora.yaml \
		-f docker-compose-euro-office.yaml \
		-f docker-compose-onlyoffice.yaml \
		-f docker-compose-zap.yaml \
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
