#this state file install wildfly, configure, create wildfly service and deploy keycloak
{% import 'lib.sls' as lib with context %}

{% set wildfly_zip_file = keycloak-1.6.1.Final.tar.gz %}

{% set wildfly_extracted_folder = '/usr/local/keycloak-1.6.1.Final' %}
{% set wildfly_home = '/usr/local/wildfly' %}

{% if lib.isKeycloakServer() == "True" %}
download-wildfly:
  archive.extracted:
    - name: /usr/local/
    - source: salt://wildfly-files/{{ wildfly_zip_file }}
    - archive_format: tar
    - tar_options: v
    - if_missing: {{ wildfly_extracted_folder }}
                
             
{% endif %} 