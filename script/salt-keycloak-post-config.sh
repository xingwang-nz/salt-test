#!/bin/bash
if [ -n "$1" ]; then
   sudo salt "$1" state.sls keycloak-post-config.sls
else
  echo "usage: salt-keycloak-post-config <minion_id>"
fi
