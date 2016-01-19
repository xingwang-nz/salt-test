{% import 'lib.sls' as lib with context %}

{% set force_reload_keycloak_config = salt['pillar.get']('force_reload_keycloak_config') %}
{% if force_reload_keycloak_config == 'True' or force_reload_keycloak_config == 'true' %}
  {% set is_force_reload_config =  'True' %}
{% else %}  
  {% set is_force_reload_config =  'False' %}
{% endif %}

{% set redirect_ics_web = 'tms-web/*' %}
{% set ics_web_type = 'TMS_WEB' %}
{% set ics_service_type = 'ICS_SERVICE' %}

{% set keycloak_server_domain = salt['pillar.get']('keycloak_server:domain_name') %}

{% set keycloak_master_admin_username = salt['pillar.get']('keycloak_master_admin_username') %}
{% set keycloak_master_admin_password = salt['pillar.get']('keycloak_master_admin_password') %}

{% set java_create_realm_command = 'java -cp ' + lib.keycloak_bin_folder + '/' + lib.keycloak_bootstrap_jar + ' com.invenco.ics.keycloak.main.KeycloakCreateClientLauncher' %}
{% set java_create_user_command = 'java -cp ' + lib.keycloak_bin_folder + '/' + lib.keycloak_bootstrap_jar + ' com.invenco.ics.keycloak.main.KeycloakCreateUserLauncher' %}

{% if lib.isNginxServer() == "True" or lib.isTmsServer() == "True" %}
include:
  - keycloak-bootstrap-jar

copy-kcbootstrap-properties-file:
  file.managed:
    - name: {{ lib.keycloak_bin_folder }}/kcbootstrap.properties
    - source: salt://wildfly-files/kcbootstrap.properties
    - mode: 755
    - template: jinja

{% if lib.isNginxServer() == "True" %}
create-keycloak-config-file-folder:
  file.directory:
    - name: /usr/share/nginx/html/keycloak
    - mode: 755
    - makedirs: True
{% endif %}    

{% for realm, details in salt['pillar.get']('realms').items() %}
create-realm-{{ realm }}:
  cmd.run:
  {% if is_force_reload_config == 'False' %}
    {% if lib.isNginxServer() == "True" %}
    - unless: ls /usr/share/nginx/html/keycloak/{{ realm }}-keycloak.json | grep "{{ realm }}-keycloak.json"
    {% else %}
    - unless: ls {{ lib.keycloak_config_folder }}/{{ realm }}-keycloak.json | grep "{{ realm }}-keycloak.json"
    {% endif %}
  {% endif %}
    - name: {{ java_create_realm_command }} "{{ lib.keycloak_bin_folder }}/kcbootstrap.properties" "{{ realm }}" {% if lib.isNginxServer() == "True" %}"{{ ics_web_type }}"{% else %}"{{ ics_service_type }}"{% endif %} {% if keycloak_server_domain != None and keycloak_server_domain != '' %}"https://{{ keycloak_server_domain }}/auth"{% else %}"https://{{ details.get('domain_name') }}/auth"{% endif %} "https://{{ details.get('domain_name') }}/{{ redirect_ics_web }}"    
    - require:
      - file: copy-kcbootstrap-properties-file

{% if lib.isTmsServer() == "True" and details.get('users') != None %}
{% for realm_user, realm_user_details in details.get('users').items() %}
create-realm-{{ realm }}-user-{{ realm_user }}:
  cmd.run:
    - name: {{ java_create_user_command }} "{{ lib.keycloak_bin_folder }}/kcbootstrap.properties" "{{ realm }}" "{{ realm_user }}" "{{ realm_user_details.get('password') }}" "{{ realm_user_details.get('first_name') }}" "{{ realm_user_details.get('last_name') }}" "{{ realm_user_details.get('role') }}"
{% endfor %}
{% endif %}

{% endfor %}


{% if lib.isTmsServer() == "True" %}
#restart tomcat
stop-tomcat-reload-keycloak-config:
  cmd.run:
    - onlyif: ls /etc/init.d/tomcat | grep tomcat
    - name: sudo /etc/init.d/tomcat stop

wait-for-stop-tomcat-reload-keycloak-config:
  cmd.run:
    - name: sleep 10

start-tomcat-reload-keycloak-config:
  cmd.run:
    - onlyif: ls /etc/init.d/tomcat | grep tomcat
    - name: sudo /etc/init.d/tomcat start       
{% endif %}  

{% endif %}