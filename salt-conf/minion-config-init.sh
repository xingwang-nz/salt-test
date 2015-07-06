#!/bin/bash
if [[ -z "$1" ]];then
  echo "usage: config-minion-server-role.sh <minion-server-role>"
  exit 1
fi

restart_service=true
if sudo grep  -E "^grains:" -A 1 /etc/salt/minion | grep -q -E "^  server_role: $1"; then
  restart_service=false
  echo "server_role is already set"
elif sudo grep  -E "^grains:" -A 1 /etc/salt/minion | grep -q -E "^  server_role:"; then
  #update config
  echo "update server_role config"
  sudo sed -i -r 's/^  server_role: (.){1,}/\ \ server_role: '"$1"/i1 /etc/salt/minion
elif sudo grep -q -E "^grains:" /etc/salt/minion; then
  echo "insert server_role config line"
  sudo sed -i '/^grains:$/ a \ \ server_role: '"$1" /etc/salt/minion
else
  echo "insert grains and server_role lines"

  (sudo echo "grains:" | sudo tee -a /etc/salt/minion) >> /dev/null

  sudo sed -i '/^grains:$/ a \ \ server_role: '"$1" /etc/salt/minion

  #(sudo echo "  server_role: $1" | sudo tee -a /etc/salt/minion) >> /dev/null

  #sudo service salt-minion restart

fi

if [ "$restart_service" = true ]; then
  sudo service salt-minion restart
fi