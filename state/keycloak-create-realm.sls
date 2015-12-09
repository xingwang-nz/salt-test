{% import 'lib.sls' as lib with context %}

{% if lib.isNginxServer() == "True" or lib.isTmsServer() == "True" %}
include:
  - keycloak-bootstrap-jar

copy-kcbootstrap-properties-file:
  file.managed:
    - name: {{ lib.keycloak_bin_folder }}/kcbootstrap.properties
{% if lib.isNginxServer() == "True" %}
    - source: salt://wildfly-files/kcbootstrap-nginx-server.properties    
{% else %}    
    - source: salt://wildfly-files/kcbootstrap-tomcat-server.properties
{% endif %}    
    - user: wildfly
    - group: wildfly
    - mode: 644
    - template: jinja

{% for realm, details in salt['pillar.get']('realms').items() %}
create-realm-{{ realm }}:
  cmd.run:
    - name: java -cp {{ lib.keycloak_bin_folder }}/{{ lib.keycloak_bootstrap_jar }} com.invenco.ics.keycloak.main.KeycloakBootstrapLauncher  "{{ lib.keycloak_bin_folder }}/kcbootstrap.properties" "{{ realm }}" {% if lib.isNginxServer() == "True" %}"tms-web"{% else %}"ics-service"{% endif %}
    - require:
      - file:copy-kcbootstrap-properties-file
{% endfor %}

  

{% endif %}    