{% import 'lib.sls' as lib with context %}

{% if lib.isTmsServer() == "True" %}
create-tomcat-group:
  group.present:
    - name: tomcat
    - gid:  4000
    
create-tomcat-user:
  user.present:
    - name: tomcat
    - uid: 4000
    - gid: 4000
    - shell: /usr/sbin/nologin
    - require:
      - group: create-tomcat-group
{% endif %}

# for keycloak
{% if lib.isKeycloakServer() == "True" %}
create-keycloak-group:
  group.present:
    - name: keycloak
    
create-keycloak-user:
  user.present:
    - name: keycloak
    - shell: /usr/sbin/nologin
    - groups:
      - keycloak
    - require:
      - group: create-keycloak-group
{% endif %}
      
{% for username, details in salt['pillar.get']('ec2_server:user_accounts').items() %}
create-group-{{ username }}:
  group.present:
    - name: {{ username }}

create-user-{{ username }}:
  user.present:
    - name: {{ username }}
    - shell: /bin/bash
    - home: /home/{{ username }}
    - uid: {{ details.get('uid', '') }}
    - gid: {{ details.get('gid', '') }}
    - groups:
      - {{ username }}
{% if lib.isTmsServer() == "True" %}        
      - tomcat
{% endif %}
{% if lib.isKeycloakServer() == "True" %}        
      - keycloak
{% endif %}    
      - users
{% if details.get('is_sudo') == True %}
      - sudo
{% endif %}
    - require:
      - group: create-group-{{ username }}
{% if lib.isTmsServer() == "True" %}       
      - group: create-tomcat-group
{% endif %}      

{% if details.get('is_sudo') == True %}
add-{{ username }}-no-password-in-sudoers:
  file.append:
    - name: /etc/sudoers
    - text: 
      - "{{ username }} ALL=(ALL) NOPASSWD: ALL"
    - require:
      - user: create-user-{{ username }}          
{% endif %}

ssh-key-{{ username }}:
  ssh_auth.present:
    - user: {{ username }}
    - source: salt://pub-keys/{{ username }}_id_rsa.pub
    - require:
      - user: create-user-{{ username }}

{% endfor %}
      
      