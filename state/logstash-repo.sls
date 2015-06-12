{% import 'lib.sls' as lib with context %}
{% set logstash_conf_folder = '/etc/logstash/conf.d' %}

{% if lib.isLogstashServer() == "True" %}
logstash-repo-key:
  cmd.run:
    - name: wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
    - unless: apt-key list | grep 'Elasticsearch (Elasticsearch Signing Key)'
    
logstash-repo:
  pkgrepo.managed:
    - humanname: Logstash Debian Repository
    - name: deb http://packages.elasticsearch.org/logstash/1.5/debian stable main
    - require:
      - cmd: logstash-repo-key

install-logstash:
  pkg.installed:
    - name: logstash
    - skip_verify: True
    - skip_suggestions: True
    - require:
      - cmd: logstash-repo

#Configure logstash
config-logstash:
  file.managed:
    - name: {{ logstash_conf_folder }}/logstash.conf
    - source: salt://logstash-files/logstash.conf
    - mode: 644
    - makedirs: True
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