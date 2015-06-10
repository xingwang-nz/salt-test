{% import 'lib.sls' as lib with context %}

{% set nginx_conf_folder = '/etc/nginx' %}
{% set tms_nginx_conf_filename = 'tms-nginx.conf' %}
{% set tms_nginx_conf_file = nginx_conf_folder + '/sites-available/' + tms_nginx_conf_filename %}
{% set tms_nginx_conf_linkfile = nginx_conf_folder + '/sites-enabled/' + tms_nginx_conf_filename %}
{% set tms_nginx_conf_html_root = '/usr/share/nginx/html' %}


{% if lib.isNginxServer() == "True" %}
#install nginx
install-nginx:
  pkg.installed:
    - name: nginx
    - skip_suggestions: True

nginx-remove-default-config:
  file.absent:
    - name: /etc/nginx/sites-enabled/default
    - require:
      - pkg: install-nginx

nginx-setup-config:
  file.managed:
    - name: {{ tms_nginx_conf_file }}
    - source: salt://nginx/tms-nginx.conf
    - mode: 644
    - template: jinja
    - require:
      - pkg: install-nginx

nginx-error-page:
  file.managed:
    - name: {{ tms_nginx_conf_html_root }}/503.html
    - source: salt://nginx/503.html
    - mode: 644
    - template: jinja
    - require:
      - pkg: install-nginx
      
create-tms-nginx-conf-link:
  file.symlink:
    - name: {{ tms_nginx_conf_linkfile }}
    - target: {{ tms_nginx_conf_file }}
    - file.exists:
      - name: {{ tms_nginx_conf_file }}
    - require:
      - file: nginx-setup-config

#server private key      
nginx-server-certificate-key:
  file.managed:
    - name: /etc/nginx/ssl/server.key
    - source: salt://keystore/server.key
    - makedirs: True
    - mode: 400
    - require:
      - pkg: install-nginx
 
 #server certificate      
nginx-server-certificate:
  file.managed:
    - name: /etc/nginx/ssl/server-chain.crt
    - source: salt://keystore/server-chain.crt
    - makedirs: True
    - mode: 400
    - require:
      - pkg: install-nginx

#start nginx
nginx-service:
  service.running:
    - name: nginx
    - enable: True
    - require:
      - pkg: install-nginx
      - file: nginx-setup-config
      - file: create-tms-nginx-conf-link
      - file: nginx-server-certificate-key
      - file: nginx-server-certificate
    - watch:
      - file: nginx-setup-config
      - file: nginx-server-certificate-key
      - file: nginx-server-certificate
      - file: nginx-error-page
      
{% endif %}