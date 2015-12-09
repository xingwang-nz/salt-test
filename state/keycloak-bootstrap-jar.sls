{% import 'lib.sls' as lib with context %}

{% set keycloak_bootstrap_jar_source = 'ics-keycloak-bootstrap-0.0.1.jar' %}

{% if lib.isKeycloakServer() == "True" or lib.isNginxServer() == "True" or lib.isTmsServer() == "True" %}
# create keycloak folder
create-keycloak-bin-folder:
  file.directory:
    - name: {{ lib.keycloak_bin_folder }}
    - mode: 755
    - makedirs: True

create-keycloak-config-folder:
  file.directory:
    - name: {{ lib.keycloak_config_folder }}
    - mode: 755
    - makedirs: True
    
# create api-doc niginx files root folder
copy-keycloak-bootstrap-jar:
  file.managed:
    - name: {{ lib.keycloak_bin_folder }}/{{ lib.keycloak_bootstrap_jar }}
    - source: salt://wildfly-files/{{ keycloak_bootstrap_jar_source }}
    - user: wildfly
    - group: wildfly
    - mode: 644
    - template: jinja
    - require:
      - file: create-keycloak-bin-folder

{% endif %}   