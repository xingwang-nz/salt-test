{% set username = salt['pillar.get']('deleted_user_name') %}

delete-user-{{ username }}:
  user.absent:
    - name: {{ username }}
    - purge: True
    - force: True
    
#remove-{{ username }}-no-password-in-sudoers:
#    cmd.run:
#    - name: sudo sed -i '/^{{ username }} ALL=(ALL) NOPASSWD/d' /etc/sudoers
#    - require:
#      - user: delete-user-{{ username }}