{% import 'lib.sls' as lib %}
{% set message = salt['pillar.get']('hello_message') + 'master branch' %}


{% set setup_keycloak_realm_flag = salt['pillar.get']('setup_kc_realm') %}
{% if setup_keycloak_realm_flag == 'True' or setup_keycloak_realm_flag == 'true' %}
  {% set setup_keycloak_realm =  'True' %}
{% else %}  
  {% set setup_keycloak_realm =  'False' %}
{% endif %}


{% set force_reload_keycloak_config = salt['pillar.get']('force_reload_keycloak_config') %}
{% if force_reload_keycloak_config == 'True' or force_reload_keycloak_config == 'true' %}
  {% set is_force_reload_config =  'True' %}
{% else %}  
  {% set is_force_reload_config =  'False' %}
{% endif %}

{% set kc_master_admin_username = salt['pillar.get']('kc_master_admin_username') %}
{% set kc_master_admin_password = salt['pillar.get']('kc_master_admin_password') %}



#echo-hello-pillar:
#  cmd.run:
#    - name: echo "{{ salt['pillar.get']('hello_message') }}"

#echo-hello-state:
#  cmd.run:
#    - name: echo "master hello state with branch changes - 2"
    
#echo-minion-id:
#  cmd.run:
#    - name: echo "grain id- {{ lib.id }}"

{% if setup_keycloak_realm == 'True' and (lib.isNginxServer() == "True" or lib.isTmsServer() == "True") %}

{% for realm, details in salt['pillar.get']('realms').items() %}
echo-{{ realm }}-domain-name:
  cmd.run:
    - name: echo "domain_name- {{ details.get('domain_name') }}"

echo-{{ realm }}-content_server_doamin_name:
  cmd.run:
    - name: echo "content_server_doamin_name - {{ details.get('content_server_doamin_name') }}"    
{% endfor %}

display-ke-admin-login:
  cmd.run:
    - name: echo "setup_keycloak_realm={{ setup_keycloak_realm }}, force_reload_keycloak_config={{ force_reload_keycloak_config }}, kc_master_admin_username={{ kc_master_admin_username }}, kc_master_admin_password={{ kc_master_admin_password }}"

genetate-servers:
  cmd.run:
    - name: echo "server_name{% for realm, details in salt['pillar.get']('realms').items() %} {{ details.get('content_server_doamin_name') }}{% endfor %};"

  
{% endif %}