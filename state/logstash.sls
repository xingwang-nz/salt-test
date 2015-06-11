{% import 'lib.sls' as lib with context %}
{% set logstash_conf_folder = '/etc/logstash/conf.d' %}

{% if lib.isLogstashServer() == "True" %}
install-logstash:
  pkg.installed:
    - sources:
      - elasticsearch: salt://logstash-files/logstash_1.5.0-1_all.deb

#Configure Elasticsearch
config-logstash:
  file.managed:
    - name: {{ logstash_conf_folder }}
    - source: 
      - salt://logstash-files/logstash-conf/*
    - mode: 644
    - template: jinja
    - require:
      - pkg: install-logstash
      
logstash-service:
  service.running:
    - name: logstash
    - enable: True
    - require:
      - pkg: install-logstash
      - file: config-logstash
    - watch:
      - file: config-logstash
{% endif %}