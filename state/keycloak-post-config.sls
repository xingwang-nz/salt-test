################################################################################
# this state is used to perform some initialization of keycloak server. 
# 1. delete UPDATE_PASSWORD  required_action from user_required_action to enable use default admin login (admin/admin) to call api to change password
# 2. update admin password
# IMPORTANT: only run once and run after keycloak server is installed
################################################################################
{% import 'lib.sls' as lib with context %}

{% set admin_current_password = salt['pillar.get']('keycloak_admin_current_password') %}

{% set sql_command = 'psql -U ' + lib.keycloak_db_username + ' -h ' + lib.dbhost + ' -d ' + lib.keycloak_dbname + ' -c' %}

{% if lib.isKeycloakServer() == "True" %}
include:
  - keycloak-bootstrap-jar

delete-update-password-user-action:
  cmd.run:
    - name: {{ sql_command }} "delete from user_required_action where required_action = 'UPDATE_PASSWORD';"
    - env:
      - PGPASSWORD: {{ lib.keycloak_db_password }}
    - unless: {{ sql_command }} "SELECT required_action FROM user_required_action where required_action='UPDATE_PASSWORD';" | grep  UPDATE_PASSWORD

change-keycloak-admin-password:
  cmd.run:
    - name "java -cp {{ lib.keycloak_bin_folder }}/{{ lib.keycloak_bootstrap_jar }} com.invenco.ics.keycloak.main.KeycloakChangePasswordLauncher "{{ salt['pillar.get']('keycloak:host') }}/auth" {{ salt['pillar.get']('keycloak:admin:username') }} {{ admin_current_password }} {{ salt['pillar.get']('keycloak:admin:password') }} "security-admin-console""
{% endif %}      