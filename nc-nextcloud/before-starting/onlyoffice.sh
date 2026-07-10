#!/bin/sh

set -e

echo "Configuring ONLYOFFICE..."

php occ config:app:set onlyoffice DocumentServerUrl --value="/oo-editors/"
php occ config:app:set onlyoffice verify_peer_off --value "true"
php occ config:app:set onlyoffice DocumentServerInternalUrl --value="http://nc-onlyoffice-documentserver/"
php occ config:app:set onlyoffice jwt_secret --value="nc_jwt_secret"
