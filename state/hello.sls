{% if lib.isTmsServer() == "True" or lib.isLogstashServer() == "True" %}
echo-hello:
  cmd.run:
    - name: echo "{{ salt['pillar.get']('hello_message') }} dev branch"

echo-server-role:
  cmd.run:
    - name: echo {{ lib.server_role }}
    
echo-minion-id:
  cmd.run:
    - name: echo {{ lib.id }}
{% endif %}