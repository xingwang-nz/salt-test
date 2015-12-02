{% import 'lib.sls' as lib with context %}

{% set rsyslog_config_file = '/etc/rsyslog.conf' %} 

{% if lib.isTmsServer() == "True" or lib.isNginxServer() == "True" or lib.isKeycloakServer() == "True" %}
install-rsyslog:
  pkg.installed:
    - name: rsyslog
    - skip_suggestions: True

config-rsyslog-conf:
  file.managed:
    - name: {{ rsyslog_config_file }}
    - source: salt://log-agent-files/rsyslog/rsyslog.conf
    - template: jinja
    - require:
      - pkg: install-rsyslog
      
config-auditd-rsyslog:
  file.managed:
    - name: /etc/rsyslog.d/auditd-rsyslog.conf
    - source: salt://log-agent-files/rsyslog/auditd-rsyslog.conf
    - makedirs: True
    - template: jinja
    - require:
      - pkg: install-rsyslog
             
{% if lib.isNginxServer() == "True" %}
config-nginx-rsyslog:
  file.managed:
    - name: /etc/rsyslog.d/nginx-rsyslog.conf
    - source: salt://log-agent-files/rsyslog/nginx-rsyslog.conf
    - makedirs: True
    - template: jinja
    - require:
      - pkg: install-rsyslog
{% endif %}

{% if lib.isTmsServer() == "True" %}
config-tomcat-rsyslog:
  file.managed:
    - name: /etc/rsyslog.d/tomcat-rsyslog.conf
    - source: salt://log-agent-files/rsyslog/tomcat-rsyslog.conf
    - makedirs: True
    - template: jinja
    - require:
      - pkg: install-rsyslog
{% endif %}
      
rsyslog-service:
  service.running:
    - name: rsyslog
    - enable: True
    - require:
      - pkg: install-rsyslog
      - file: config-rsyslog-conf
    - watch:
      - file: config-rsyslog-conf
      - file: config-auditd-rsyslog
{% if lib.isNginxServer() == "True" %}      
      - file: config-nginx-rsyslog
{% endif %}
{% if lib.isTmsServer() == "True" %}      
      - file: config-tomcat-rsyslog
{% endif %}

restart-rsyslog-service:
  cmd.wait:
    - name: sudo service rsyslog restart
    - watch:
      - file: config-rsyslog-conf
      - file: config-auditd-rsyslog      
{% if lib.isNginxServer() == "True" %}      
      - file: config-nginx-rsyslog
{% endif %}
{% if lib.isTmsServer() == "True" %}      
      - file: config-tomcat-rsyslog
{% endif %}

{% endif %}