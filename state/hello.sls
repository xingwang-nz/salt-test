echo-hello:
  cmd.run:
    - name: echo "{{ salt['pillar.get']('hello_message') }} master branch"