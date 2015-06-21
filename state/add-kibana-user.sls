{% import 'lib.sls' as lib with context %}


{% if lib.isLogstashServer() == "True" %}
#add-kibana-user:
#  webutil.user_exists:
#    - name: {{ kibana_username }}
#    - password: {{ kibana_password }}
#    - htpasswd_file: {{ salt['pillar.get']('ht_password:password_file') }}
#    - options: d
#    - force: true

add-kibana-user:
  cmd.run:
    - name: echo "abcd "

    
{% endif %}