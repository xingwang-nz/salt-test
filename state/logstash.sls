{% import 'lib.sls' as lib with context %}

{% if lib.isLogstashServer() == "True" %}
install-elasticsearch:
  pkg.installed:
    - sources:
      - elasticsearch: salt://logstash/elasticsearch-1.6.0.deb
      
#Remove Elasticsearch Public Access
config-elasticsearch:
  file.append:
    - name: /etc/elasticsearch/elasticsearch.yml
    - text: 
      - "network.bind_host: localhost"
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