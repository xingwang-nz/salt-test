copy-s3-file:
  file.managed:
    - name: /opt/s3-file.zip
    - source:  salt://AutoTest.zip
    - mode: 644
