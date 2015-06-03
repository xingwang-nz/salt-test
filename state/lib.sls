{% set id = salt['pillar.get']('id') %}
{% set nginx_id = salt['pillar.get']('nginx_server_id') %}

{% if id ==  nginx_id %}
  {% set is_nginx_server = True %}
{% else %}
  {% set is_nginx_server = False %}
{% endif %} 