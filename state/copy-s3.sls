copy-s3-file:
  file.managed:
    - name: /opt/s3-file.zip
    - source:  salt://3c9ea36a-100b-4246-9f53-be89eb50926c/AutoTest.zip
    - mode: 644
