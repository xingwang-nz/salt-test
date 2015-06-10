ec2_server:
  time_zone: Pacific/Auckland
  tms_server_domain_name: invenco-nz-stage.tms.invenco.com
  content_server_domain_name: 172.25.115.107
  
  nginx_server_id: ubuntu-server-minion-2
  
  user_accounts:
    xing:
      is_sudo: True
      
hello_message: "hello from"      
 
tms_db:
  host: test-db-host
  port: 5432
  dbname: tms_server_db
    
ssl: 
  protocols:
    - TLSv1
    - TLSv1.1
    - TLSv1.2
#    - SSLv2Hello
  enable_sslv2hello: False
    
tms:
  tms_war: sdemo-1.1.0.war
  
  s3_bucket: invenco-nz-qa-tmsfiles-configuration-target

  #for site system, this is disabled
  enable_g6opt: True
  
  create_tms_test_user: True

  load_test_data: True

  #list of tms features to be disabled
  disabled_features:
    - CONFIGURATION
    - RELEASE
    