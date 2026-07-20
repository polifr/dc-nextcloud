#!/bin/sh

set -e

echo "Installing Nextcloud Office (eurooffice app)..."

php occ app:install eurooffice || true
