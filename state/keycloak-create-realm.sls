{% import 'lib.sls' as lib with context %}

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
    - name: java -cp {{ lib.keycloak_bin_folder }}/{{ lib.keycloak_bootstrap_jar }} com.invenco.ics.keycloak.main.KeycloakBootstrapLauncher  "{{ lib.keycloak_bin_folder }}/kcbootstrap.properties" "{{ realm }}" {% if lib.isNginxServer() == "True" %}"tms-web"{% else %}"ics-service"{% endif %}
    - require:
      - file: copy-kcbootstrap-properties-file
{% endfor %}

  

{% endif %}    