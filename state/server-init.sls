{% import 'lib.sls' as lib with context %}

include:
  - server-common
{% if lib.isNginxServer() == "True" %}
  - nginx
#  - rsyslog
{% elif lib.isTmsServer() == "True" %}
  - postgresql-client
  - rsyslog
{% elif lib.isKeycloakServer() == "True" %}
  - postgresql-client
  - rsyslog
{% elif lib.isLogstashServer() == "True" %}
  - elasticsearch
  - apache-2-utils
  - nginx
  - kibana
  - logstash-repo
#  - redis-server
{% endif %}
    