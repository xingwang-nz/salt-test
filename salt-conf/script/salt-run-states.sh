#!/bin/bash
if [ -n "$1" ]; then
   sudo salt "$1" state.highstate
else
#  sudo salt '*' state.highstate
   echo "usage: salt-run-state.sh <minion_id>"
fi

