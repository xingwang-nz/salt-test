ec2_server:
  time_zone: Pacific/Auckland
  domain_name: invenco-nz-stage.tms.invenco.com
  install_auditd: True
  user_accounts:
    - xing
    - kenk
    - rajp
    - stevenl
    
tms:
  tms_war: sdemo-1.1.0.war
  
  #ssl_protocols: TLSv1,TLSv1.1,TLSv1.2
  ssl_protocols: TLSv1.2
    
  s3_bucket: bp-nz-uat-tmsfiles

  #for site system, this is disabled
  enable_g6opt: True
  
  create_tms_test_user: True

  load_test_data: True

  #list of tms features to be disabled
  disabled_features:
    - CONFIGURATION
    - RELEASE
    