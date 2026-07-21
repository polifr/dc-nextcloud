#!/bin/sh

set -e

echo "Installing Collabora (richdocuments app)..."

php occ app:install richdocuments || true
