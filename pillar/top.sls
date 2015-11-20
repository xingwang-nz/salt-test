base:
  '*':
    - server-common
  'ubuntu-salt-minion-1,ubuntu-salt-minion-2':
    - match: list
    - ubuntu-salt-minion


dev:
  '*':
    - server-common
  'ubuntu-logstash':
    - match: list
    - ubuntu-logstash         