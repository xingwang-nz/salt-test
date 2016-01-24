base:
#  '*':
#    - server-common
  'ubuntu-salt-minion-1,ubuntu-nginx,ubuntu-keycloak':
    - match: list
    - server-common  
    - ubuntu-salt-minion


#dev:
#  '*':
#    - server-common
#  'ubuntu-logstash':
#    - match: list
#    - server-common
#    - ubuntu-logstash         