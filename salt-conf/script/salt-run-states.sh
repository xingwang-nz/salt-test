#!/bin/bash
if [ "$#" -eq 1 ]; then
    sudo salt "$1" state.highstate
elseif [ "$#" -eq 2 ]; then
    sudo salt -L "$1","$2" state.highstate
else
   echo "usage: salt-run-state.sh <minion1_id> <minion2_id> or salt-run-state.sh <minion1_id>"
fi

