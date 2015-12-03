#this state file will initialise database, create database and create tms db user.
{% import 'lib.sls' as lib with context %}

{% set sql_command = 'psql -U ' + lib.db_master_username + ' -h ' + lib.dbhost + ' -d postgres -c' %}

{% if lib.isKeycloakServer() == "True" %}
      
create-keycloak-db:
  cmd.run:
    - name: {{ sql_command }} "CREATE DATABASE {{ lib.keycloak_dbname }};"
    - env:
      - PGPASSWORD: {{ lib.db_master_password }}
    - unless: {{ sql_command }} "SELECT datname FROM pg_database where datname='{{ lib.keycloak_dbname }}';" | grep  {{ lib.keycloak_dbname }}
      
create-keycloak-db-user:
  cmd.run:
    - name: {{ sql_command }} "CREATE USER {{ lib.keycloak_db_username }} WITH PASSWORD '{{ lib.keycloak_db_password }}'; GRANT ALL PRIVILEGES ON DATABASE {{ lib.keycloak_dbname }} to {{ lib.keycloak_db_username }};"
    - env:
      - PGPASSWORD: {{ lib.db_master_password }}
    - unless: {{ sql_command }} "SELECT rolname FROM pg_roles where rolname='{{ lib.keycloak_db_username }}';" | grep  {{ lib.keycloak_db_username }}
    - require:
      - cmd: create-keycloak-db
      
{% endif %}