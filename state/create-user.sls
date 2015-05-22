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