#!/bin/bash
if [ -n "$1" ]; then
   sudo salt "$1" state.sls post-configuration
else
  echo "usage: salt-post-configuration.sh <minion_id>"
fi
