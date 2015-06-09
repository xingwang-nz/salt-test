echo-hello:
  cmd.run:
    - name: echo "{{ salt['pillar.get']('hello_message') }} master branch"

restart-tomcat-service:
  service.running:
    - name: tomcat
    - enable: True
    - watch:
      - cmd: echo-hello
