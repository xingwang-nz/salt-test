#!/bin/bash
if [ -n "$1" ]; then
	pillar_value="{\"force_reload_keycloak_config\": \"True\"}"
	sudo salt "$1" state.sls keycloak-create-realm pillar="$pillar_value"
else
	echo "usage: salt-create-realm.sh <minion_id>"
fi
