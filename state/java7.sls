#this state file install jdk1.7
{% import 'lib.sls' as lib %}

{% if lib.isTmsServer() == "True" || lib.isLogstashServer() == "True" %}
# add PPA  
oracle-ppa:
  pkgrepo.managed:
    - humanname: WebUpd8 Oracle Java PPA repository
    - ppa: webupd8team/java
 
oracle-license-select:
  cmd.run:
    - unless: which java
    - name: '/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections'
    - require_in:
      - pkg: oracle-java7-installer
      - cmd: oracle-license-seen-lie
 
oracle-license-seen-lie:
  cmd.run:
    - name: '/bin/echo /usr/bin/debconf shared/accepted-oracle-license-v1-1 seen true  | /usr/bin/debconf-set-selections'
    - require_in:
      - pkg: oracle-java7-installer
 
oracle-java7-installer:
  pkg:
    - installed
    - require:
      - pkgrepo: oracle-ppa
{% endif %}      