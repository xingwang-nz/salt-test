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

# change the PID_DIR from "/var/run/elasticsearch" to "/var/run"
# elasticsearch1.6 has a bug, the /var/run/elasticsearch folder is deleted everytime when ubuntu reboot, 
# as a result, the process id won't be able to written to the folder and the service cannot be restarted  
elasticsearch-change-pid-folder:
  file.append:
    - name: /etc/default/elasticsearch
    - text: 
      - "PID_DIR=/var/run"
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
      - file: elasticsearch-change-pid-folder
    - watch:
      - file: config-elasticsearch
      - file: elasticsearch-change-pid-folder
      
restart-elasticsearch-service:
  cmd.wait:
    - name: /etc/init.d/elasticsearch restart
    - watch:
        - file: config-elasticsearch
        - file: elasticsearch-change-pid-folder
         
{% endif %}