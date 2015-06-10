base:
  'server_role:tms-server':
    - match: grain  
    - server-init
    - create-user-accounts
    - java7
    - tomcat
    - hello
  'server_role:nginx-server':
    - match: grain
    - server-init
    - create-user-accounts
      
#dev:
#  'ubuntu-salt-minion-2':
#    - server-init
#    - create-user-accounts
#    - hello
