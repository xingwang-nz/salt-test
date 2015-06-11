{% import 'lib.sls' as lib with context %}

{% set kibana_extracted_folder = '/usr/local/kibana-4.1.0-linux-x64' %}
{% set kibana_home = '/usr/local/kibana' %}

{% if lib.isLogstashServer() == "True" %}
download-kibana:
  archive.extracted:
    - name: /usr/local/
    - source: salt://logstash-files/kibana-4.1.0-linux-x64.tar.gz    
    - archive_format: tar
    - tar_options: v
    - if_missing: {{ kibana_extracted_folder }}
    
create-kibana-link:
  file.symlink:
    - name: {{ kibana_home }}
    - target: {{ kibana_extracted_folder }}
    - file.exists:
      - name: {{ kibana_extracted_folder }}
    - require:
      - archive: download-kibana

upload-kibana-deamon-script:
  file.managed:
    - name: /etc/init.d/kibana
    - source: salt://logstash-files/kibana.sh
    - user: root
    - group: root
    - mode: 755
    - require:
      - archive: download-kibana

config-kibana:
  file.managed:
    - name: {{ kibana_home }}/config/kibana.yml
    - source: salt://logstash-files/kibana.yml
    - makedirs: True
    - template: jinja
    - require:
      - archive: download-kibana   

#start tomcat service            
kibana-service:
  service.running:
    - name: kibana
    - enable: True
    - require:
      - archive: download-kibana
      - file: upload-kibana-deamon-script
      - file: config-kibana
    - watch:
      - file: upload-kibana-deamon-script
      - file: config-kibana

{% endif %}