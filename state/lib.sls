{% set id = salt['grains.get']('id') %}
{% set server_role = salt['grains.get']('server_role') %}

{% macro isNginxServer() -%}
  {%- if server_role == 'nginx-server' -%}
    True
  {%- else -%}
    False
  {%- endif -%}
{%- endmacro %}

{% macro isTmsServer() -%}
  {%- if server_role == 'tms-server' -%}
    True
  {%- else -%}
    False
  {%- endif -%}
{%- endmacro %}

{% macro isLogstashServer() -%}
  {%- if server_role == 'logstash-server' -%}
    True
  {%- else -%}
    False
  {%- endif -%}
{%- endmacro %}

{% macro isKeycloakServer() -%}
  {%- if server_role == 'keycloak-server' -%}
    True
  {%- else -%}
    False
  {%- endif -%}
{%- endmacro %}

{% if server_role == 'nginx-server' %}
  {% set nginx_conf_filename = 'tms-nginx.conf' %}
{% elif server_role == 'logstash-server' %}
  {% set nginx_conf_filename = 'kibana-nginx.conf' %}
{% else %}
  {% set nginx_conf_filename = '' %}
{% endif %}


{% if salt['pillar.get']('kibana_server:host') == None or salt['pillar.get']('kibana_server:host') == '' %}
  {% set kibana_server_host = salt['pillar.get']('logging_server:host') %}
{% else %}
  {% set kibana_server_host = salt['pillar.get']('kibana_server:host') %}
{% endif %}

{% set dbhost = salt['pillar.get']('tms_db:host') %}
{% set dbport = salt['pillar.get']('tms_db:port') %}
{% set dbname = salt['pillar.get']('tms_db:dbname') %}
{% set db_master_username = salt['pillar.get']('tms_db:master_username') %}
{% set db_master_password = salt['pillar.get']('tms_db:master_password') %}
{% set db_username = salt['pillar.get']('tms_db:username') %}
{% set db_password = salt['pillar.get']('tms_db:password') %}

{% set keycloak_dbname = salt['pillar.get']('tms_db:keycloak_dbname') %}
{% set keycloak_db_username = salt['pillar.get']('tms_db:keycloak_username') %}
{% set keycloak_db_password = salt['pillar.get']('tms_db:keycloak_password') %}


