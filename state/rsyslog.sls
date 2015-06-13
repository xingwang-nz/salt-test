{% import 'lib.sls' as lib with context %}

{% if lib.isTmsServer() == "True" %}
install-rsyslog:
  pkg.installed:
    - name: rsyslog
    - skip_suggestions: True
{% endif %}