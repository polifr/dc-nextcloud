#!/bin/sh

set -e

echo "Installing ONLYOFFICE (onlyoffice app)..."

php occ app:install onlyoffice || true
