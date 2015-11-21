{% import 'lib.sls' as lib %}
{% set message = salt['pillar.get']('hello_message') + 'master branch' %}

echo-hello-pillar:
  cmd.run:
    - name: echo "{{ salt['pillar.get']('hello_message') }}"

echo-hello-state:
  cmd.run:
    - name: echo "master hello state with branch changes - 2"
    
echo-minion-id:
  cmd.run:
    - name: echo "grain id- {{ lib.id }}"
