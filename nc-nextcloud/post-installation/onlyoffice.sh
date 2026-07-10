#!/bin/sh

set -e

echo "Installing ONLYOFFICE..."

php occ app:install onlyoffice || true
php occ app:enable onlyoffice || true
