#!/bin/bash
if [ "$#" -eq 1 ]; then
    sudo salt "$1" state.highstate
elif [ "$#" -eq 2 ]; then
   if [ "$2" = "--setup-kc-realm" ]; then
     read -p 'Keycloak master admin username: ' kc_master_admin_username
     read -sp 'Keycloak master admin password: ' kc_master_admin_password
     pillar_value="\"setup_kc_realm\": \"True\", \"kc_master_admin_username\": \""$kc_master_admin_username"\", \"kc_master_admin_password\": \""$kc_master_admin_password"\"}"
     echo ""
     echo "$pillar_value"
     #sudo salt "$1" state.highstate  pillar="$pillar_value"
   else
     echo "usage: salt-run-state.sh <minion1_id> [--setup-kc-realm] or salt-run-state.sh <minion1_id>"
   fi
else
   echo "usage: salt-run-state.sh <minion1_id> [--setup-kc-realm] or salt-run-state.sh <minion1_id>"
fi