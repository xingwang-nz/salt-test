################################################################################
# this state is used to perform some initialization of keycloak server. 
# 1. delete UPDATE_PASSWORD  required_action from user_required_action to enable use default admin login (admin/admin) to call api to change password
# 2. update admin password
# IMPORTANT: only run once and run after keycloak server is installed
################################################################################
{% import 'lib.sls' as lib with context %}

{% if lib.isKeycloakServer() == "True" %}
include:
  - keycloak-bootstrap-jar

{% endif %}      