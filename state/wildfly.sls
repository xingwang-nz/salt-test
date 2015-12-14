#this state file install wildfly, configure, create wildfly service and deploy keycloak
{% import 'lib.sls' as lib with context %}

{% set wildfly_zip_file = 'keycloak-1.6.1.Final.tar.gz' %}

{% set wildfly_extracted_folder = '/usr/local/keycloak-1.6.1.Final' %}
{% set wildfly_home = '/usr/local/wildfly' %}

{% if lib.isKeycloakServer() == "True" %}
download-wildfly:
  archive.extracted:
    - name: /usr/local/
    - source: salt://wildfly-files/{{ wildfly_zip_file }}
    - archive_format: tar
    - tar_options: v
    - if_missing: {{ wildfly_extracted_folder }}

create-wildfly-link:
  file.symlink:
    - name: {{ wildfly_home }}
    - target: {{ wildfly_extracted_folder }}
    - file.exists:
      - name: {{ wildfly_extracted_folder }}
    - require:
      - archive: download-wildfly

upload-wildfly-service-start-stop-script:
  file.managed:
    - name: /etc/init.d/wildfly
    - source: salt://wildfly-files/wildfly.sh
    - user: root
    - group: root
    - mode: 755
    - require:
      - archive: download-wildfly

create-postgresql-jdbc-deploy-folder:
  file.directory:
    - name: {{ wildfly_home }}/modules/org/postgresql/main
    - user: wildfly
    - group: wildfly
    - mode: 755
    - makedirs: True      

upload-postgresql-jdbc-driver:
  file.managed:
    - name: {{ wildfly_home }}/modules/org/postgresql/main/postgresql-9.4-1206-jdbc4.jar
    - source: salt://wildfly-files/postgresql-9.4-1206-jdbc4.jar
    - user: wildfly
    - group: wildfly
    - mode: 755
    - require:
      - file: create-postgresql-jdbc-deploy-folder

upload-postgresql-jdbc-driver-module-xml:
  file.managed:
    - name: {{ wildfly_home }}/modules/org/postgresql/main/module.xml
    - source: salt://wildfly-files/module.xml
    - user: wildfly
    - group: wildfly
    - mode: 755
    - template: jinja    
    - require:
      - file: create-postgresql-jdbc-deploy-folder
      
upload-wildfly-standalone-xml:
  file.managed:
    - name: {{ wildfly_home }}/standalone/configuration/standalone.xml
    - source: salt://wildfly-files/standalone.xml
    - user: wildfly
    - group: wildfly
    - mode: 755
    - template: jinja
    - require:
      - file: create-wildfly-link

upload-keycloak-server-json:
  file.managed:
    - name: {{ wildfly_home }}/standalone/configuration/keycloak-server.json
    - source: salt://wildfly-files/keycloak-server.json
    - user: wildfly
    - group: wildfly
    - mode: 755
    - template: jinja
    - require:
      - file: create-wildfly-link

copy-custom-theme:
  file.recurse:
    - name: {{ wildfly_home }}/standalone/configuration/themes/invenco
    - source: salt://wildfly-files/theme/invenco
    - user: wildfly
    - dir_mode: 755
    - file_mode: 755
    - include_empty: True
    - require:
      - file: create-wildfly-link
      
change-owner-to-wildfly:
  file.directory:
    - name: {{ wildfly_extracted_folder }}
    - user: wildfly
    - group: wildfly
    - recurse:
      - user
      - group
    - require:
      - archive: download-wildfly
    - unless:
      - stat -c "%U" {{ wildfly_extracted_folder }} | grep wildfly

#start wildfly service            
wildfly-service:
  service.running:
    - name: wildfly
    - enable: True
    - require:
      - file: upload-wildfly-service-start-stop-script
      - file: upload-postgresql-jdbc-driver
      - file: upload-postgresql-jdbc-driver-module-xml
      - file: upload-wildfly-standalone-xml
      - file: upload-keycloak-server-json
    - watch:
      - file: upload-wildfly-service-start-stop-script
      - file: upload-postgresql-jdbc-driver
      - file: upload-postgresql-jdbc-driver-module-xml
      - file: upload-wildfly-standalone-xml
      - file: upload-keycloak-server-json  

wait-for-wildfly-service:
  cmd.run:
    - name: sleep 10
                
stop-wildfly-service:
  cmd.run:
    - name: sudo service wildfly stop

wait-for-wildfly-service-stop:
  cmd.run:
    - name: sleep 5
    
restart-wildfly-service:
  cmd.run:
    - name: sudo service wildfly start 
{% endif %} 