base:
#  'ubuntu-salt-minion-1':
  '*':  
    - server-init
    - create-user-accounts
    - java7
    - tomcat
    - hello
#dev:
#  'ubuntu-salt-minion-2':
#    - server-init
#    - create-user-accounts
#    - hello
