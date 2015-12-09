#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "usage: salt-keycloak-post-config.sh <minion_id> <keycloak_admin_current_password>"
	exit 1
else
	pillar_value="{\"keycloak_admin_current_password\": \""$2"\"}"
	read -p "Are you sure you want to run this salt state, the admin password will be updated (yY/nN)?" choice
	case "$choice" in
      y|Y ) sudo salt "$1" state.sls salt-keycloak-post-config pillar="$pillar_value";;
      * ) exit 1;;
     esac
fi
