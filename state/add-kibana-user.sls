{% import 'lib.sls' as lib with context %}

{% set kibana_username = salt['pillar.get']('kibana_username') %}
{% set kibana_password = salt['pillar.get']('kibana_password') %}

{% if lib.isLogstashServer() == "True" %}
add-kibana-user:
  webutil.user_exists:
    - name: {{ kibana_username }}
    - password: {{ kibana_password }}
    - htpasswd_file: {{ salt['pillar.get']('ht_password:password_file') }}
    - options: d
    - force: true

{% endif %}
      
      