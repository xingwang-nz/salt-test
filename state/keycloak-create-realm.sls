{% import 'lib.sls' as lib with context %}

{% set force_reload_keycloak_config = salt['pillar.get']('force_reload_keycloak_config') %}
{% if force_reload_keycloak_config == 'True' or force_reload_keycloak_config == 'true' %}
  {% set is_force_reload_config =  'True' %}
{% else %}  
  {% set is_force_reload_config =  'False' %}
{% endif %}

{% set ics_web = 'tms-web' %}

{% set ics_web_type = 'TMS_WEB' %}
{% set ics_service_type = 'ICS_SERVICE' %}

{% set keycloak_server_domain = salt['pillar.get']('keycloak_server:domain_name') %}


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
    - name: java -cp {{ lib.keycloak_bin_folder }}/{{ lib.keycloak_bootstrap_jar }} com.invenco.ics.keycloak.main.KeycloakCreateClientLauncher  "{{ lib.keycloak_bin_folder }}/kcbootstrap.properties" "{{ realm }}" "{{ ics_web_type }}" "https://{{ details.get('domain_name') }}/{{ ics_web }}" "https://{{ keycloak_server_domain }}/auth"
    {% else %}
    - unless: ls {{ lib.keycloak_config_folder }}/{{ realm }}-keycloak.json | grep "{{ realm }}-keycloak.json"
    - name: java -cp {{ lib.keycloak_bin_folder }}/{{ lib.keycloak_bootstrap_jar }} com.invenco.ics.keycloak.main.KeycloakCreateClientLauncher  "{{ lib.keycloak_bin_folder }}/kcbootstrap.properties" "{{ realm }}" "{{ ics_service_type }}"
    {% endif %}  
  {% endif %}
    
    - require:
      - file: copy-kcbootstrap-properties-file
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