#!/bin/bash
if [ -n "$1" ]; then
     read -p 'Keycloak master admin username: ' kc_master_admin_username
     read -sp 'Keycloak master admin password: ' kc_master_admin_password
     pillar_value="{\"setup_kc_realm\": \"True\", \"kc_master_admin_username\": \""$kc_master_admin_username"\", \"kc_master_admin_password\": \""$kc_master_admin_password"\"}"
     echo ""
	sudo salt "$1" state.sls keycloak-setup-realm pillar="$pillar_value"
else
	echo "usage: salt-create-realm.sh <minion_id>"
fi
