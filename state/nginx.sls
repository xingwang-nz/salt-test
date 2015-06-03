{% set id = salt['pillar.get']('id') %}
{% set nginx_id = salt['pillar.get']('nginx_server_id') %}

{% if id == nginx_id %} 
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
    - name: /etc/nginx/sites-available/tms-nginx-conf
    - source: salt://nginx/tms-nginx-conf
    - mode: 644
    - template: jinja
    - require:
      - pkg: install-nginx

#server private key      
nginx-server-certificate-key:
  file.managed:
    - name: /etc/nginx/ssl/server-key.pem
    - source: salt://ssl/server-key.pem
    - makedirs: True
    - mode: 400
    - require:
      - pkg: install-nginx
 
 #server certificate      
nginx-server-certificate:
  file.managed:
    - name: /etc/nginx/ssl/server-cert.pem;
    - source: salt://ssl/server-cert.pem;
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
      - file: nginx-server-certificate-key
      - file: nginx-server-certificate
    - watch:
      - file: nginx-setup-config
      - file: nginx-server-certificate-key
      - file: nginx-server-certificate
{% endif %}