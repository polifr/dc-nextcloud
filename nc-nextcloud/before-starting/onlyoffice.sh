#!/bin/sh

set -e

echo "Configuring ONLYOFFICE..."

php occ config:app:set onlyoffice DocumentServerUrl --value="http://nc-onlyoffice-document-server"
