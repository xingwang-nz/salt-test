#!/bin/bash
if [ -n "$1" ]; then
   sudo salt "$1" state.sls tomcat
else
  #sudo salt '*' state.sls create-user-accounts
  echo "usage: salt-tomcat-tms-deploy.sh <minion_id>"
fi
