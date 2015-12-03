base:
  'server_role:tms-server':
    - match: grain
 #   - create-user-accounts
 #   - java7          
 #   - server-init
 #   - tomcat
    - hello
    
  'server_role:nginx-server':
    - match: grain
#    - create-user-accounts    
#    - server-init
#    - api-doc
    - hello    

  'server_role:keycloak-server':
    - match: grain
    - create-user-accounts
    - server-init
    - keycloak-db-init
    - java8
    - wildfly
 
        
#  'server_role:logstash-server':
#    - match: grain
#    - create-user-accounts
#    - java7        
#    - server-init
#    - hello
    
dev:
  'server_role:logstash-server':
    - match: grain
#    - create-user-accounts    
#    - server-init
#    - api-doc
    - hello 
