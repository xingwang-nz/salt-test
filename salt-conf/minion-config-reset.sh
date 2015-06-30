#!/bin/bash
#script to make this instance to be ready create image
# 1. reset /etc/salt/minion 
# 2. stop salt-minion service
# 3. delete /etc/salt/minion_id /etc/salt/pki


minion_config_file=/etc/salt/minion
if sudo grep -q -E "^grains:$" "$minion_config_file"; then
  sudo sed -i '/^grains:$/d' "$minion_config_file"
fi

if sudo grep -q -E "server_role: " "$minion_config_file"; then
  sudo sed -i '/server_role:/d' "$minion_config_file"
fi

#sudo service salt-minion stop

sudo rm -rf /etc/salt/minion_id /etc/salt/pki