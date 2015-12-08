{% import 'lib.sls' as lib %}
{% set message = salt['pillar.get']('hello_message') + 'master branch' %}

#echo-hello-pillar:
#  cmd.run:
#    - name: echo "{{ salt['pillar.get']('hello_message') }}"

#echo-hello-state:
#  cmd.run:
#    - name: echo "master hello state with branch changes - 2"
    
#echo-minion-id:
#  cmd.run:
#    - name: echo "grain id- {{ lib.id }}"

{% for realm, details in salt['pillar.get']('realms').items() %}
echo-{{ realm }}-domain-name:
  cmd.run:
    - name: echo "domain_name- {{ details.get('domain_name') }}"

echo-{{ realm }}-content_server_doamin_name:
  cmd.run:
    - name: echo "content_server_doamin_name - {{ details.get('content_server_doamin_name') }}"    
{% endfor %}

genetate-servers:
  cmd.run:
    - name: echo "server_name{% for realm, details in salt['pillar.get']('realms').items() %} {{ details.get('content_server_doamin_name') }} {% endfor %};"

  
