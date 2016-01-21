{% set setup_keycloak_realm_flag = salt['pillar.get']('setup_kc_realm') %}
{% if setup_keycloak_realm_flag == 'True' or setup_keycloak_realm_flag == 'true' %}
  {% set setup_keycloak_realm =  'True' %}
{% else %}  
  {% set setup_keycloak_realm =  'False' %}
{% endif %}

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
    - server-init
#    - java8
#    - keycloak-setup-realm
#    - hello    
#    - hello    

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
