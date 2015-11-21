{% import 'lib.sls' as lib %}
{% set message = salt['pillar.get']('hello_message') + 'master branch' %}

echo-hello:
  cmd.run:
    - name: echo "{{ message }} - with branch change"

echo-server-role:
  cmd.run:
    - name: echo "server role- {{ salt['pillar.get']('hello_message') }}  master branch- with branch change"
    
echo-minion-id:
  cmd.run:
    - name: echo "grain id- {{ lib.id }}  master branch- with branch change"
