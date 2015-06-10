{% import 'lib.sls' as lib with context%}

include:
  - server-common
{% if lib.isNginxServer() == "True" %}
  - nginx
{% elif lib.isTmsServer() == "True" %}
  - postgresql-client
{% elif lib.isLogstashServer() == "True" %}
  - logstash
{% endif %}
    