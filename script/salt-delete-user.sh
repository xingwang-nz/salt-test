#!/bin/bash
if [ -n "$1" ]; then
   pillar_value="{\"deleted_user_name\": \""$1"\"}"
   if [ -n "$2" ]; then
     sudo salt "$2" state.sls delete-user pillar="$pillar_value"
   else
     echo "usage: salt-delete-user.sh <username> [minion_id]"
   fi

else
  echo "usage: salt-delete-user.sh <username> [minion_id]"
fi