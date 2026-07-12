#!/bin/sh

set -e

echo "Configuring Nextcloud Office..."

php occ config:app:set eurooffice DocumentServerUrl --value="/editors/"
php occ config:app:set eurooffice verify_peer_off --value "true"
php occ config:app:set eurooffice DocumentServerInternalUrl --value="http://nc-euro-office-documentserver/"
php occ config:app:set eurooffice jwt_secret --value="nc_jwt_secret"
