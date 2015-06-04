{% set id = salt['grains.get']('id') %}
{% set nginx_id = salt['pillar.get']('ec2_server:nginx_server_id') %}

{% macro isNginxServer() -%}
  {%- if id == nginx_id -%}
    True
  {%- else -%}
    False
  {%- endif -%}
{%- endmacro %}

{% set dbhost = salt['pillar.get']('tms_db:host') %}
{% set dbport = salt['pillar.get']('tms_db:port') %}
{% set dbname = salt['pillar.get']('tms_db:dbname') %}
{% set db_master_username = salt['pillar.get']('tms_db:master_username') %}
{% set db_master_password = salt['pillar.get']('tms_db:master_password') %}
{% set db_username = salt['pillar.get']('tms_db:username') %}
{% set db_password = salt['pillar.get']('tms_db:password') %}



