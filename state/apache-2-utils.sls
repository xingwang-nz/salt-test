
{% import 'lib.sls' as lib with context %}
{% if lib.isLogstashServer() == "True" %}

# can command "sudo htpasswd -c /etc/htpasswd.users <username>" to add new user 
install-apache2-utils:
  pkg.installed:
    - name: apache2-utils
    - skip_suggestions: True

# add a default user
add-default-kibana-user:
  webutil.user_exists:
    - name: {{ salt['pillar.get']('kibana:default_user') }}
    - password: {{ salt['pillar.get']('kibana:default_passwd') }}
    - htpasswd_file: {{ salt['pillar.get']('ht_password:password_file') }}
    - options: d
    - force: true    
{% endif %}