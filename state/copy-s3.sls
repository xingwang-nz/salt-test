copy-s3-file:
  file.managed:
    - name: /opt/s3-file.zip
    - source:  salt://deploy/ics-db-1.1.48.jar
    - mode: 644

copy-s3-file-2:
  file.managed:
    - name: /opt/tms-api-2.0.91.war
    - source:  salt://deploy/tms-api-2.0.91.war
    - mode: 644