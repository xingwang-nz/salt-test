#this state file install tomcat, configure tomcat, create tomcat service and deploy tms  
{% set tomcat_extracted_folder = '/usr/local/apache-tomcat-8.0.21' %}
{% set tomcat_home = '/usr/local/tomcat' %}

include:
  - state-common
  
{% if is_nginx_server == False %}   
download-tomcat:
  archive.extracted:
    - name: /usr/local/
#    - source: http://apache.mirrors.tds.net/tomcat/tomcat-8/v8.0.21/bin/apache-tomcat-8.0.21.tar.gz
    - source: salt://tomcat-files/apache-tomcat-8.0.21.tar.gz    
    - source_hash: md5=7972dfc3a1e9b9a78738379f7e755a11
    - archive_format: tar
    - tar_options: v
#    - user: root
#    - group: root
#    - mode: 775
    - if_missing: {{ tomcat_extracted_folder }}
     
create-tomcat-link:
  file.symlink:
    - name: {{ tomcat_home }}
    - target: {{ tomcat_extracted_folder }}
    - file.exists:
      - name: {{ tomcat_extracted_folder }}
    - require:
      - archive: download-tomcat
      
upload-tomcat-service-start-stop-script:
  file.managed:
    - name: /etc/init.d/tomcat
    - source: salt://tomcat-files/tomcat.sh
    - user: root
    - group: root
    - mode: 755
    - require:
      - archive: download-tomcat
      
#add script deploment manager
upload-tomcat-users-xml:
  file.managed:
    - name: {{ tomcat_home }}/conf/tomcat-users.xml
    - source: salt://tomcat-files/tomcat-users.xml
    - user: tomcat
    - group: tomcat
    - mode: 644
    - template: jinja
    - require:
      - file: create-tomcat-link      
      
#change the tomcat folder owner to tomcat unless the owner was tomcat    
change-owner-to-tomcat:
  file.directory:
    - name: {{ tomcat_extracted_folder }}
    - user: tomcat
    - group: tomcat
    - recurse:
      - user
      - group
    - require:
      - archive: download-tomcat
    - unless:
      - stat -c "%U" {{ tomcat_extracted_folder }} | grep tomcat

#start tomcat service            
tomcat-service:
  service.running:
    - name: tomcat
    - enable: True
    - require:
      - file: upload-tomcat-service-start-stop-script
      - file: upload-tomcat-users-xml
      - file: change-owner-to-tomcat
    - watch:
      - file: upload-tomcat-service-start-stop-script
      - file: upload-tomcat-users-xml

wait-for-tomcat_start:
  cmd.run:
    - name: sleep 10
          
#start deployment
wait-for-tomcat-manager:
  tomcat.wait:
    - timeout: 300
    - require:
      - service: tomcat-service

tms-deployment:
  tomcat.war_deployed:
    - name: /sdemo
    - war: salt://deploy/{{ salt['pillar.get']('tms:tms_war') }}
    - url: http://localhost:8080/manager
    - timeout: 180
    - require:
      - tomcat: wait-for-tomcat-manager
{% endif %}       