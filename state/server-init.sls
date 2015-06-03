{% from 'lib.sls' import is_nginx_server with context %}

set-time-zone:
  timezone.system:
    - name: {{ salt['pillar.get']('ec2_server:time_zone') }}

# install auditd    
install-auditd:
  pkg.installed:
    - name: auditd
    - skip_suggestions: True

# configure audit rules to capture all commands  
configure-audit-rules:
  file.append:
    - name: /etc/audit/audit.rules
    - text: 
      - "-a exit,always -F arch=b64 -S execve"
      - "-a exit,always -F arch=b32 -S execve"
    - require:
      - pkg: install-auditd

# set audit buffer to "-b 1024"
set-audit-buffer:
  cmd.run:
    - name: sed -i 's/-b[ ][0-9]\+/-b 1024/' /etc/audit/audit.rules
    - require:
      - pkg: install-auditd    
    - unless:
      - grep "\-b 1024" /etc/audit/audit.rules 

# start auditd service
auditd-service:
  service.running:
    - name: auditd
    - enable: True
    - require:
      - pkg: install-auditd
      - file: configure-audit-rules
    - watch:
      - file: configure-audit-rules
      - cmd: set-audit-buffer

# install ntp for server time synchronisation
# default minpoll=64s maxpoll=1024s(about 17minutes), expect time synchronization happends every 64 second ~ 17 minutes 
install-ntp:
  pkg.installed:
    - name: ntp
    - skip_suggestions: True
    
{% if is_nginx_server == True %}
include:
  - nginx
{% endif %}    
    