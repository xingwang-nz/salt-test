{% import 'lib.sls' as lib with context %}

{% set nginx_conf_folder = '/etc/nginx' %}
{% set nginx_main_conf_file = nginx_conf_folder + '/nginx.conf' %}

{% set nginx_conf_file = nginx_conf_folder + '/sites-available/' + lib.nginx_conf_filename %}
{% set nginx_conf_linkfile = nginx_conf_folder + '/sites-enabled/' + lib.nginx_conf_filename %}
{% set nginx_conf_html_root = '/usr/share/nginx/html' %}


{% if lib.isNginxServer() == "True" or lib.isLogstashServer() == "True" %}
add-nginx-ppa-stable:
  pkgrepo.managed:
    - ppa: nginx/stable
    
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

# increase server_names_hash_bucket_size  to be 256
increase-server-names-hash-bucket-size:
  cmd.run:
    - name: sudo sed -i '/include \/etc\/nginx\/conf.d\/\*[.]conf;$/i\        server_names_hash_bucket_size   256;' {{ nginx_main_conf_file }}
    - require:
      - pkg: install-nginx
    - unless: grep "server_names_hash_bucket_size   256;" {{ nginx_main_conf_file }}
    
echo-nginx-setup-config-file-{{ lib.server_role }}:
  cmd.run:
    - name: echo "nginx-conf-file={{ lib.nginx_conf_filename }}"
    
nginx-setup-config:
  file.managed:
    - name: {{ nginx_conf_file }}
    - source: salt://nginx/tms-nginx-local.conf
    - mode: 644
    - template: jinja
    - require:
      - pkg: install-nginx

nginx-error-page:
  file.managed:
    - name: {{ nginx_conf_html_root }}/503.html
    - source: salt://nginx/503.html
    - mode: 644
    - template: jinja
    - require:
      - pkg: install-nginx
      
create-nginx-conf-link:
  file.symlink:
    - name: {{ nginx_conf_linkfile }}
    - target: {{ nginx_conf_file }}
    - file.exists:
      - name: {{ nginx_conf_file }}
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
      - file: create-nginx-conf-link
      - file: nginx-server-certificate-key
      - file: nginx-server-certificate
    - watch:
      - file: nginx-setup-config
      - file: nginx-server-certificate-key
      - file: nginx-server-certificate
      - file: nginx-error-page

restart-nginx-service:
  cmd.wait:
    - name: /etc/init.d/nginx restart
    - watch:
      - file: nginx-setup-config
      - file: nginx-server-certificate-key
      - file: nginx-server-certificate
      - file: nginx-error-page      
{% endif %}