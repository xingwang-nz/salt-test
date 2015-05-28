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
      - tomcat
      - users
      {% if details.get('is_sudo') == True %}
      - sudo
      {% endif %}
    - require:
      - group: create-group-{{ username }}
      - group: create-tomcat-group

{% if details.get('is_sudo') == True %}
add-{{ username }}-no-password-in-sudoers:
  file.append:
    - name: /etc/sudoers
    - text: 
      - "{{ username }} ALL=(ALL) NOPASSWD: ALL"
    - require:
      - user: create-user-{{ username }}          
{% endif %}

{% endfor %}
      
      