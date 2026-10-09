# dc-nextcloud
A docker-compose based repository to check deployment of Nextcloud Files and connectors (i.e. OnlyOffice, Euro Office) with basic backend services (Redis, Postgresql).

These Nextcloud apps are installed by default during setup:
- [calendar](https://apps.nextcloud.com/apps/calendar)
- [spreed](https://apps.nextcloud.com/apps/spreed) (aka Nextcloud Talk - audio/video conferencing, web meetings and text chat)
- [deck](https://apps.nextcloud.com/apps/deck) (kanban style organization tool)
- [tasks](https://apps.nextcloud.com/apps/tasks)
- [forms](https://apps.nextcloud.com/apps/forms) (surveys, polls and questionnaires creation)
- [groupfolders](https://apps.nextcloud.com/apps/groupfolders)

Currently, it integrates with OnlyOffice and Euro Office Document Server; configuration for Collabora integration on this project is still under development.

## How to run the project (fast)

Add the following to the system `hosts` file:
```
127.0.0.1  nextcloud.local
```

Generate the (self-signed) certificates for nginx, using the `make create-certificates` command.

Launch `make start` to run the docker compose project with Nextcloud and Onlyoffice (more options listed in the next section).

Log in the local Nextcloud instance using <https://nextcloud.local>, as `admin` or `test` user (both have `my-n3xtcl0u4` as password).


## Makefile options
- `make create-certificates` creates self signed certificates for https usage on nginx (run once then forget it)
- `make start-onlyoffice` starts docker compose with Nextcloud and OnlyOffice
- `make stop-onlyoffice` stops docker compose with Nextcloud and OnlyOffice
- `make reset-onlyoffice` deletes docker compose with Nextcloud and OnlyOffice (services, volumes and network)
- `make start-euro-office` starts docker compose with Nextcloud and Euro Office
- `make stop-euro-office` stops docker compose with Nextcloud and Euro Office
- `make reset-euro-office` deletes docker compose with Nextcloud and Euro Office (services, volumes and network)
- `make start-collabora` starts docker compose with Nextcloud and Collabora
- `make stop-collabora` stops docker compose with Nextcloud and Collabora
- `make reset-collabora` deletes docker compose with Nextcloud and Collabora (services, volumes and network)
- `make start` alias for `make start-onlyoffice`
- `make stop` alias for `make stop-onlyoffice`
- `make reset` alias for `make reset-onlyoffice`
- `make clean` clears everything for any of the described solutions (OnlyOffice, Euro Office, Collabora)
- `make update` updates all the project docker images, currently useful to test Euro Office releases


## Docker images references and versions:
- <https://hub.docker.com/_/nextcloud> 35
- <https://hub.docker.com/r/onlyoffice/documentserver> 9.4
- <https://github.com/Euro-Office/DocumentServer> latest
- <https://hub.docker.com/r/collabora/code> latest
- <https://hub.docker.com/_/redis> 8
- <https://hub.docker.com/_/postgres> 18
- <https://hub.docker.com/_/nginx> 1.31

## Inspiring references:
- <https://github.com/ONLYOFFICE/docker-onlyoffice-nextcloud>
- <https://www.heyvaldemar.com/install-nextcloud-with-onlyoffice-using-docker-compose/>
- <https://helpcenter.onlyoffice.com/installation/docs-nextcloud-proxy.aspx>
- <https://help.nextcloud.com/t/docker-nextcloud-onlyoffice-let-s-encrypt-nginx-samba-cron/113030>
- <https://github.com/Destripador/docker-nextcloud-onlyoffice>

## TODO List
- Add an LDAP server for centralized users / group management (eg. using <https://hub.docker.com/r/osixia/openldap>)
- Add a mail server for Nextcloud notifications (eg. using <https://hub.docker.com/r/mailserver/docker-mailserver/>)
