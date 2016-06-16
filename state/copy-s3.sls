copy-s3-file:
  file.managed:
    - name: /opt/s3-file.zip
    - source:  salt://ics-db-1.1.48.jar
    - mode: 644
