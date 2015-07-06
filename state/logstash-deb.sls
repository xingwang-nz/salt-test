{% import 'lib.sls' as lib with context %}
{% set logstash_conf_folder = '/etc/logstash/conf.d' %}

{% if lib.isLogstashServer() == "True" %}
install-logstash:
  pkg.installed:
    - sources:
      - logstash: salt://logstash-files/logstash_1.5.0-1_all.deb

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