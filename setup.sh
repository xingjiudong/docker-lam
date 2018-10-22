#!/bin/bash
set -e

LAM_CONF_FILE=/var/www/html/lam/config/lam.conf

: ${LDAP_URL:=ldap://openldap}
: ${LDAP_PORT:=389}
: ${SLAPD_DN:=dc=example,dc=com}
: ${LDAP_ADMIN:=cn=admin,dc=example,dc=com}
: ${USER_DN:=ou=people,dc=example,dc=com}
: ${GROUP_DN:=ou=group,dc=example,dc=com}

if [ ! -f "$LAM_CONF_FILE" ]; then
    sed -e "s#serverURL: ldap://localhost:389#ServerURL: ${LDAP_URL}:${LDAP_PORT}#g" /var/www/html/lam/config/lam.conf.default > ${LAM_CONF_FILE}
    sed -i "s/admins: cn=Manager,dc=my-domain,dc=com/Admins: ${LDAP_ADMIN}/g" ${LAM_CONF_FILE}
    sed -i "s/treesuffix: dc=yourdomain,dc=org/treesuffix: ${SLAPD_DN}/g" ${LAM_CONF_FILE}
    sed -i "s/types: suffix_user: ou=People,dc=my-domain,dc=com/types: suffix_user: ${USER_DN}/g" ${LAM_CONF_FILE}
    sed -i "s/types: suffix_group: ou=group,dc=my-domain,dc=com/types: suffix_group: ${GROUP_DN}/g" ${LAM_CONF_FILE}
fi

exec /usr/local/bin/apache2-foreground
