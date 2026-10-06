# dc-nextcloud
A docker-compose based repository to check deployment of NextCloud Files and connectors (i.e. OnlyOffice, Euro Office) with basic backend services (Redis, Postgresql).

These NextCloud apps are installed by default during setup:
- calendar
- spreed
- deck
- tasks
- forms
- groupfolders

Currently, works for OnlyOffice and Euro Office; configuration for Collabora is still under development.

Before using this, you have to add the following to `hosts` file:
```
127.0.0.1  nextcloud.local
```
These are the `Makefile` commands:
- `make start-onlyoffice` starts docker compose with NextCloud and OnlyOffice
- `make stop-onlyoffice` stops docker compose with NextCloud and OnlyOffice
- `make reset-onlyoffice` deletes docker compose with NextCloud and OnlyOffice (services, volumes and network)
- `make start-euro-office` starts docker compose with NextCloud and Euro Office
- `make stop-euro-office` stops docker compose with NextCloud and Euro Office
- `make reset-euro-office` deletes docker compose with NextCloud and Euro Office (services, volumes and network)
- `make start-collabora` starts docker compose with NextCloud and Collabora
- `make stop-collabora` stops docker compose with NextCloud and Collabora
- `make reset-collabora` deletes docker compose with NextCloud and Collabora (services, volumes and network)
- `make start` alias for `make start-onlyoffice`
- `make stop` alias for `make stop-onlyoffice`
- `make reset` alias for `make reset-onlyoffice`
- `make clean` clears everything for any of the described solutions (OnlyOffice, Euro Office, Collabora)
- `make update` updates all the project docker images, currently useful to test Euro Office releases

Then you can log in NextCloud using <http://nextcloud.local> url, as the `admin` or `test` user (both have `my-n3xtcl0u4` as password).


Docker images references:
- <https://hub.docker.com/_/nextcloud>
- <https://hub.docker.com/r/onlyoffice/documentserver>
- <https://hub.docker.com/_/redis>
- <https://hub.docker.com/_/postgres>
- <https://hub.docker.com/_/nginx> for reverse proxy

Inspiring references:
- <https://github.com/ONLYOFFICE/docker-onlyoffice-nextcloud>
- <https://www.heyvaldemar.com/install-nextcloud-with-onlyoffice-using-docker-compose/>
- <https://helpcenter.onlyoffice.com/installation/docs-nextcloud-proxy.aspx>
- <https://help.nextcloud.com/t/docker-nextcloud-onlyoffice-let-s-encrypt-nginx-samba-cron/113030>
- <https://github.com/Destripador/docker-nextcloud-onlyoffice>
