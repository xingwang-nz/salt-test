{% import 'lib.sls' as lib %}

echo-hello:
  cmd.run:
    - name: echo "{{ salt['pillar.get']('hello_message') }} master branch"

echo-server-role:
  cmd.run:
    - name: echo "server role: {{ lib.server_role }}"
    
echo-minion-id:
  cmd.run:
    - name: echo "grain id: {{ lib.id }}"
