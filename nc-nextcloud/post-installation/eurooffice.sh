#!/bin/sh

set -e

echo "Installing Nextcloud Office..."

php occ app:install eurooffice || true
