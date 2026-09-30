#!/bin/sh

set -e

echo "Installing Additional Apps..."

php occ app:install calendar || true
php occ app:install spreed || true
php occ app:install deck || true
php occ app:install tasks || true
php occ app:install forms || true
