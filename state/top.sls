base:
  'server_role:tms-server':
    - match: grain
    - create-user-accounts
    - java7          
    - server-init
    - tomcat
#    - hello
    
  'server_role:nginx-server':
    - match: grain
    - create-user-accounts    
    - server-init
#    - hello    
    
  'server_role:logstash-server':
    - match: grain
    - create-user-accounts
    - java7        
    - server-init
#    - hello    
#dev:
#  'ubuntu-salt-minion-2':
#    - server-init
#    - create-user-accounts
#    - hello
