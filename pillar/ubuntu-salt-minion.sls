ec2_server:
  time_zone: Pacific/Auckland
  tms_server_domain_name: invenco-nz-stage.tms.invenco.com
  content_server_domain_name: 172.25.115.107
  
  #nginx_server_id: ubuntu-server-minion-2
  #nginx_server_id:
  
  user_accounts:
    xing:
      is_sudo: True
  
ssl: 
  protocols:
    - TLSv1
    - TLSv1.1
    - TLSv1.2
#    - SSLv2Hello
    
tms:
  tms_war: sdemo-1.1.0.war
  
  #ssl_protocols: TLSv1,TLSv1.1,TLSv1.2
  ssl_protocols: TLSv1.2
    
  s3_bucket: invenco-nz-qa-tmsfiles-configuration-target

  #for site system, this is disabled
  enable_g6opt: True
  
  create_tms_test_user: True

  load_test_data: True

  #list of tms features to be disabled
  disabled_features:
    - CONFIGURATION
    - RELEASE
    