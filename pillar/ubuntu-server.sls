time_zone: Pacific/Auckland

#ssl_protocols: TLSv1,TLSv1.1,TLSv1.2
ssl_protocols: TLSv1.2


landing_page_domain: bp-nz-uat.tms.invenco.com
tms_war: tms-webapp-1.3.12.war
user_accounts:
  - xing
  - kenk
  - rajp
  - stevenl

s3_bucket: bp-nz-uat-tmsfiles

create_tms_test_user: True

#for site system, this is disabled
enable_g6opt: True

load_test_data: True

#list of tms feature to be disabled
disabled_features:
  - CONFIGURATION
  - RELEASE