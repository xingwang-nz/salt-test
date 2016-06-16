copy-s3-file:
  file.managed:
    - name: /opt/s3-file.zip
#    - source: s3://invenco-dev-ics-cloud-upload/d0ada63e-8924-4597-af66-d357c9dbfc66/AutoTest.zip
#    - source_hash: md5=s3://invenco-dev-ics-cloud-upload/d0ada63e-8924-4597-af66-d357c9dbfc66/AutoTest.zip
    - source: s3://invenco-dev-ics-cloud-upload/d0ada63e-8924-4597-af66-d357c9dbfc66/AutoTest.zip
    - mode: 644
