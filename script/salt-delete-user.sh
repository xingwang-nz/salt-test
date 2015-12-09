#!/bin/bash
if [ -n "$1" ]; then
   pillar_value="{\"deleted_user_name\": \""$1"\"}"
   if [ -n "$2" ]; then
     sudo salt "$2" state.sls delete-ssh-user pillar="$pillar_value"
   else
     read -p "Are you sure you want to delete user $1 from all servers (yY/nN)?" choice
     case "$choice" in
      y|Y ) sudo salt '*' state.sls delete-ssh-user pillar="$pillar_value";;
      * ) exit 1;;
     esac
   fi
else
  echo "usage: salt-delete-ssh-user.sh <username> [minion_id] or  salt-delete-user.sh <username>"
fi
