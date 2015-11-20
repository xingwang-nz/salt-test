{% import 'lib.sls' as lib %}
{% set message = salt['pillar.get']('hello_message') + 'master branch' %}

echo-hello:
  cmd.run:
    - name: echo "aaa"

echo-server-role:
  cmd.run:
    - name: echo "server role"
#    - name: echo "server role: {{ lib.server_role }}  master branch"
    
echo-minion-id:
  cmd.run:
    - name: echo "grain id"
    #- name: echo "grain id: {{ lib.id }}  master branch"
