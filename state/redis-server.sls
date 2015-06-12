{% import 'lib.sls' as lib with context %}

{% if lib.isLogstashServer() == "True" %}

install-redis-server:
  pkg.installed:
    - name: redis-server
    - skip_verify: True
    - skip_suggestions: True

config-redis:
  file.managed:
    - name: /etc/redis/redis.conf
    - source: salt://logstash-files/redis.conf
    - makedirs: True
    - template: jinja
    - require:
      - pkg: install-redis-server
      
start-redis-service:
  service.running:
    - name: redis-server
    - enable: True
    - require:
      - pkg: install-redis-server
      - file: config-redis
    - watch:
      - file: config-redis

restart-redis-service:
  cmd.wait:
    - name: /etc/init.d/redis restart
    - watch:
      - file: upload-kibana-deamon-script
      - file: config-redis
{% endif %} 