{% set id = salt['pillar.get']('id') %}
{% set nginx_id = salt['pillar.get']('nginx_server_id') %}

{% macro isNginxServer() -%}
  {%- if id == nginx_id -%}
    True
  {%- else -%}
    False
  {%- endif -%}
{%- endmacro %} 