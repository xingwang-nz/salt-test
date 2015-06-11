{% import 'lib.sls' as lib with context %}

{% if lib.isLogstashServer() == "True" %}
install-elasticsearch:
  pkg.installed:
    - sources:
      - elasticsearch: salt://logstash-files/elasticsearch-1.6.0.deb

#Configure Elasticsearch
config-elasticsearch:
  file.managed:
    - name: /etc/elasticsearch/elasticsearch.yml
    - source: salt://logstash-files/elasticsearch.yml
    - mode: 644
    - template: jinja
    - require:
      - pkg: install-elasticsearch
      
elasticsearch-service:
  service.running:
    - name: elasticsearch
    - enable: True
    - require:
      - pkg: install-elasticsearch
      - file: config-elasticsearch 
    - watch:
      - file: config-elasticsearch
{% endif %}