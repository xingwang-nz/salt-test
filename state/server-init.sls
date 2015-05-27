set-time-zone:
  timezone.system:
    - name: {{ salt['pillar.get']('ec2_server:time_zone') }}