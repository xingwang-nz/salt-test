{% import 'lib.sls' as lib with context %}

{% set elasticsearch_cluster_name = salt['pillar.get']('elasticsearch:cluster_name') %}

{% if lib.isLogstashServer() == "True" %}
install-elasticsearch:
  pkg.installed:
    - sources:
      - elasticsearch: salt://logstash-files/elasticsearch-1.6.0.deb

#Configure Elasticsearch
#config-elasticsearch:
#  file.managed:
#    - name: /etc/elasticsearch/elasticsearch.yml
#    - source: salt://logstash-files/elasticsearch.yml
#    - mode: 644
#    - template: jinja
#    - require:
#      - pkg: install-elasticsearch
      
config-elasticsearch:
  file.append:
    - name: /etc/elasticsearch/elasticsearch.yml
    - text: 
      - "cluster.name: {{ elasticsearch_cluster_name }}"
      - "node.name: {{ lib.id }}"
    - require:
      - pkg: install-elasticsearch
            
elasticsearch-service:
  service.running:
    - name: elasticsearch
    - enable: True
    - reload: True
    - require:
      - pkg: install-elasticsearch
      - file: config-elasticsearch 
    - watch:
      - file: config-elasticsearch
      
restart-elasticsearch-service:
  cmd.wait:
    - name: /etc/init.d/elasticsearch restart
    - watch:
        - file: config-elasticsearch
         
{% endif %}