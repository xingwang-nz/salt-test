{% import 'lib.sls' as lib with context %}

{% if lib.isLogstashServer() == "True" %}
install-elasticsearch:
  pkg.installed:
    - sources:
      - elasticsearch: salt://logstash/elasticsearch-1.6.0.deb
      
elasticsearch-service:
  service.running:
    - name: elasticsearch
    - enable: True
    - require:
      - pkg: install-elasticsearch
#    - watch:
#      - file: configure-audit-rules
#      - cmd: set-audit-buffer      
{% endif %}