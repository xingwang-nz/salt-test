{% import 'lib.sls' as lib with context %}
install-rsyslog:
  pkg.installed:
    - name: rsyslog
    - skip_suggestions: True
{% endif %}