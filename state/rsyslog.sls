{% import 'lib.sls' as lib with context %}

{% if lib.isTmsServer() == "True" %}
install-rsyslog:
  pkg.installed:
    - name: rsyslog
    - skip_suggestions: True

config-rsyslog:
  file.managed:
    - name: /etc/rsyslog.conf
    - source: salt://log-agent-files/rsyslog/rsyslog.conf
    - makedirs: True
    - template: jinja
    - require:
      - pkg: install-rsyslog

rsyslog-service:
  service.running:
    - name: rsyslog
    - enable: True
    - require:
      - pkg: install-rsyslog
      - file: config-rsyslog
    - watch:
      - file: config-rsyslog

restart-rsyslog-service:
  cmd.wait:
    - name: sudo service rsyslog restart
    - watch:
      - file: config-rsyslog      
{% endif %}