{% set setup_keycloak_realm_flag = salt['pillar.get']('setup_kc_realm') %}
{% if setup_keycloak_realm_flag == 'True' or setup_keycloak_realm_flag == 'true' %}
  {% set setup_keycloak_realm =  'True' %}
{% else %}  
  {% set setup_keycloak_realm =  'False' %}
{% endif %}

base:
  'server_role:nginx-server':
    - match: grain
    - copy-s3
