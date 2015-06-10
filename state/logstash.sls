{% import 'lib.sls' as lib with context %}

{% if lib.isLogstashServer() == "True" %}
install-elasticsearch:
  pkg.installed:
    - sources:
      - elasticsearch: salt://logstash/elasticsearch-1.6.0.deb
{% endif %}