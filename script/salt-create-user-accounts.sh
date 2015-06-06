#!/bin/bash
if [ -n "$1" ]; then
   sudo salt "$1" state.sls create-user-accounts
else
  #sudo salt '*' state.sls create-user-accounts
  echo "usage: create-user-accounts.sh <minion_id>"
fi