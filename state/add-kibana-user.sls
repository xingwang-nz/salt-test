{% import 'lib.sls' as lib with context %}

{% if lib.isLogstashServer() == "True" %}
add-kibana-user:
  cmd.run:
    - name: echo "abcd "
{% endif %}

      
      