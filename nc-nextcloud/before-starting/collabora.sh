#!/bin/sh

set -e

echo "Configuring Collabora (richdocuments app)..."

php occ config:app:set richdocuments wopi_url --value="https://nextcloud.local"
php occ config:app:set richdocuments public_wopi_url --value="https://nextcloud.local"
php occ config:app:set richdocuments wopi_allowlist --value="172.30.0.0/24"
php occ config:app:set richdocuments disable_certificate_verification --value="yes"

echo "Waiting for Collabora..."
i=0
until curl -sfk https://nextcloud.local/hosting/discovery > /dev/null; do
    i=$((i+1))
    [ "$i" -ge 120 ] && echo "Collabora not reachable, continuing anyway" && break
    sleep 2
done

php occ richdocuments:activate-config || true
