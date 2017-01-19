#!/bin/bash
set -e

LAM_CONF_FILE=/var/www/html/lam/config/lam.conf

#Convert FQDN to LDAP base DN
SLAPD_TMP_DN=".${LDAP_DN}"
while [ -n "${SLAPD_TMP_DN}" ]; do
SLAPD_DN=",dc=${SLAPD_TMP_DN##*.}${SLAPD_DN}"
SLAPD_TMP_DN="${SLAPD_TMP_DN%.*}"
done
SLAPD_DN="${SLAPD_DN#,}"
echo ${SLAPD_DN}

sed -i "s#serverURL: ldap://localhost:389#ServerURL: ldap://${LDAP_URL}:${LDAP_PORT}#g" ${LAM_CONF_FILE}
sed -i "s/admins: cn=Manager,dc=my-domain,dc=com/Admins: cn=admin,${SLAPD_DN}/g" ${LAM_CONF_FILE}
sed -i "s/treesuffix: dc=yourdomain,dc=org/treesuffix: ${SLAPD_DN}/g" ${LAM_CONF_FILE}
sed -i "s/types: suffix_user: ou=People,dc=my-domain,dc=com/types: suffix_user: ou=People,${SLAPD_DN}/g" ${LAM_CONF_FILE}
sed -i "s/types: suffix_group: ou=group,dc=my-domain,dc=com/types: suffix_group: ou=group,${SLAPD_DN}/g" ${LAM_CONF_FILE}

exec /usr/local/bin/apache2-foreground
