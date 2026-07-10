#!/bin/sh

set -e

echo "Configuring ONLYOFFICE..."

php occ config:app:set onlyoffice DocumentServerUrl --value="/editors/"
php occ config:app:set onlyoffice DocumentServerInternalUrl --value="http://nc-onlyoffice-document-server/"
php occ config:app:set onlyoffice jwt_secret --value="nc_jwt_secret"

# echo "Checking ONLYOFFICE..."

# php occ onlyoffice:documentserver --check
