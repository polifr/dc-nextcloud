#!/bin/sh

set -e

php occ config:system:set trusted_domains 0 --value=localhost
php occ config:system:set trusted_domains 1 --value=nc-nextcloud
php occ config:system:set trusted_domains 2 --value=nextcloud.local

php occ config:system:set trusted_proxies 0 --value="172.30.0.0/24"

php occ config:system:set overwriteprotocol --value=https

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


# Configurazione ldap
php occ ldap:create-empty-config
php occ ldap:set-config s01 ldapConfigurationActive "1"
php occ ldap:set-config s01 ldapHost "ldap://nc-ldap"
php occ ldap:set-config s01 ldapPort "389"
php occ ldap:set-config s01 ldapAgentName "cn=nc-ldap-bind,dc=nextcloud,dc=local"
php occ ldap:set-config s01 ldapAgentPassword "my-n3xtcl0u4"
php occ ldap:set-config s01 ldapBase "dc=nextcloud,dc=local"
php occ ldap:set-config s01 ldapBaseUsers "dc=nextcloud,dc=local"
php occ ldap:set-config s01 ldapBaseGroups "dc=nextcloud,dc=local"
php occ ldap:set-config s01 ldapUserFilter "inetOrgPerson"
php occ ldap:set-config s01 ldapGroupFilter "(|(cn=nextcloud-admins)(cn=nextcloud-users))"
php occ ldap:set-config s01 ldapGroupFilterGroups "nextcloud-admins;nextcloud-users"
php occ ldap:set-config s01 ldapLoginFilter "(&(|(objectclass=inetOrgPerson))(|(mailPrimaryAddress=%uid)(mail=%uid)))"
php occ ldap:set-config s01 ldapLoginFilterEmail "1"
php occ ldap:set-config s01 ldapLoginFilterMode "0"
php occ ldap:set-config s01 ldapLoginFilterUsername "0"
