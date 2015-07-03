#this state file install tomcat, configure tomcat, create tomcat service and deploy tms
{% import 'lib.sls' as lib with context %}

{% set tomcat_extracted_folder = '/usr/local/apache-tomcat-8.0.21' %}
{% set tomcat_home = '/usr/local/tomcat' %}

{% if lib.isTmsServer() == "True" %}
download-tomcat:
  archive.extracted:
    - name: /usr/local/
#    - source: http://apache.mirrors.tds.net/tomcat/tomcat-8/v8.0.21/bin/apache-tomcat-8.0.21.tar.gz
    - source: salt://tomcat-files/apache-tomcat-8.0.21.tar.gz    
    - source_hash: md5=7972dfc3a1e9b9a78738379f7e755a11
    - archive_format: tar
    - tar_options: v
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

upload-tomcat-server-xml:
  file.managed:
    - name: {{ tomcat_home }}/conf/server.xml
    - source: salt://tomcat-files/server.xml
    - user: tomcat
    - group: tomcat
    - mode: 644
    - template: jinja
    - require:
      - file: create-tomcat-link

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

# remove tomcat landing file from ROOT app, as this has been handled in nginx 
remove-tomcat-landing-page:      
  file.absent:
    - name: {{ tomcat_home }}/webapps/ROOT/index.html
      
#change the tomcat folder owner to tomcat unless the owner was tomcat    
change-owner-to-tomcat:
  file.directory:
    - name: {{ tomcat_extracted_folder }}
    - user: tomcat
    - group: tomcat
#    - file_mode: 744
#    - dir_mode: 755
    - recurse:
      - user
      - group
#      - mode
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
      - file: upload-tomcat-server-xml
    - watch:
      - file: upload-tomcat-service-start-stop-script
      - file: upload-tomcat-users-xml
      - file: upload-tomcat-server-xml

wait-for-tomcat-service:
  cmd.run:
    - name: sleep 20
                
restart-tomcat-service:
  cmd.wait:
    - name: /etc/init.d/tomcat restart
    - watch:
      - file: upload-tomcat-service-start-stop-script
      - file: upload-tomcat-users-xml
      - file: upload-tomcat-server-xml
            
wait-for-tomcat-start:
  cmd.run:
    - name: sleep 20
              
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