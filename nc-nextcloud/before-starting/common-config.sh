#!/bin/sh

set -e

php occ config:system:set trusted_domains 0 --value=localhost
php occ config:system:set trusted_domains 1 --value=nc-nextcloud
php occ config:system:set trusted_domains 2 --value=nextcloud.local

php occ config:system:set overwrite.cli.url --value=http://nc-nextcloud

php occ config:system:set enable_previews \
    --type=boolean \
    --value=true

php occ config:system:set enabledPreviewProviders \
    --type=json \
    --value='[
        "OC\\Preview\\PNG",
        "OC\\Preview\\JPEG",
        "OC\\Preview\\GIF",
        "OC\\Preview\\BMP",
        "OC\\Preview\\XBitmap",
        "OC\\Preview\\Krita",
        "OC\\Preview\\WebP",
        "OC\\Preview\\MarkDown",
        "OC\\Preview\\TXT",
        "OC\\Preview\\OpenDocument",
        "OC\\Preview\\PDF"
    ]'

export OC_PASS=my-n3xtcl0u4
php occ user:add --password-from-env --display-name="Test User" --group="test-users" test
