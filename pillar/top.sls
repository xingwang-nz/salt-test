base:
  '*':
    - server-common
  'ubuntu-salt-minion-1,ubuntu-salt-minion-2':
    - match: list
    - ubuntu-salt-minion
  'ubuntu-logstash':
    - match: list
    - ubuntu-logstash