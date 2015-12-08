################################################################################
# this state is used to perform some initialization of keycloak server. 
# 1. delete UPDATE_PASSWORD  required_action from user_required_action to enable use default admin login (admin/admin) to call api to change password
# 2. update admin password
# IMPORTANT: only run once and run after keycloak server is installed
################################################################################
{% import 'lib.sls' as lib with context %}

{% set keycloak_files_root_folder = '/usr/local/ics/keycloak' %}

{% set keycloak_bin_folder = keycloak_files_root_folder + '/bin' %}

{% set keycloak_bootstrap_jar_source = 'ics-keycloak-bootstrap-0.0.1.jar' %}
{% set keycloak_bootstrap_jar = 'ics-keycloak-bootstrap.jar' %}

{% if lib.isKeycloakServer() == "True" %}
# create keycloak folder
create-keycloak-folders:
  file.directory:
    - name: {{ keycloak_bin_folder }}
    - mode: 755
    - makedirs: True

# create api-doc niginx files root folder
copy-keycloak-bootstrap-jar:
  file.managed:
    - name: {{ keycloak_bin_folder }}/{{ keycloak_bootstrap_jar }}
    - source: salt://{{ keycloak_bootstrap_jar_source }}
    - user: wildfly
    - group: wildfly
    - mode: 644
    - template: jinja
    - require:
      - file: create-keycloak-folders

{% endif %}      