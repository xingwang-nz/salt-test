#!/bin/bash
if [ -n "$1" ]; then
   sudo salt "$1" state.sls server-init
else
  echo "usage: salt-server-init.sh <minion_id>"
fi