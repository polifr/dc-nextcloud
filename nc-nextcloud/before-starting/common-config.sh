#!/bin/sh

set -e

php occ config:system:set trusted_domains 1 --value=nc-nextcloud
php occ config:system:set overwrite.cli.url --value=http://nc-nextcloud
