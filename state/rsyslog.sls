{% import 'lib.sls' as lib with context %}

{% if lib.isTmsServer() == "True" or lib.isNginxServer() == "True" %}
install-rsyslog:
  pkg.installed:
    - name: rsyslog
    - skip_suggestions: True

# add "$ModLoad imfile" to /etc/rsyslog.conf before the line  "$IncludeConfig /etc/rsyslog.d/*.conf"
rsyslog-enable-imfile:
  cmd.run:
    - name: sudo sed -i '/^[$]IncludeConfig \/etc\/rsyslog.d\/\*[.]conf$/ i $ModLoad imfile' /etc/rsyslog.conf
    - unless: grep '$ModLoad imfile' /etc/rsyslog.conf

#change rsyslog's group permissiom from syslog to adm group
rsyslog-change-group-permission:
  cmd.run:
    - name: sudo sed -i -r 's/[$]PrivDropToGroup (.){1,}$/$PrivDropToGroup adm/i1' /etc/rsyslog.conf
    - unless: grep '$PrivDropToGroup adm' /etc/rsyslog.conf
  
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
      - cmd: rsyslog-enable-imfile
    - watch:
      - cmd: rsyslog-enable-imfile
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
      - cmd: rsyslog-enable-imfile
      - file: config-auditd-rsyslog
{% if lib.isNginxServer() == "True" %}      
      - file: config-nginx-rsyslog
{% endif %}
{% if lib.isTmsServer() == "True" %}      
      - file: config-tomcat-rsyslog
{% endif %}

{% endif %}