{% import 'lib.sls' as lib with context%}

{% if lib.isTmsServer() == "True" %}
#add ppa for postgresql-client9.4:
add-postgresql-repository:
  file.managed:
    - name: /etc/apt/sources.list.d/pgdg.list
    - contents: deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main

add-pgdg-ppa-key:
  cmd.run:
    - name: wget -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
    - unless: apt-key list | grep ACCC4CF8

install-postgresql-client:
  pkg.installed:
    - name: postgresql-client-9.4
    - skip_verify: True
    - skip_suggestions: True
    - refresh: True  
{% endif %}