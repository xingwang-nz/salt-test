base:
#  '*':
#    - server-common
  'ubuntu-salt-minion-1,ubuntu-salt-minion-2,ubuntu-keycloak':
    - match: list
    - server-common  
    - ubuntu-salt-minion


dev:
#  '*':
#    - server-common
  'ubuntu-logstash':
    - match: list
    - server-common
    - ubuntu-logstash         