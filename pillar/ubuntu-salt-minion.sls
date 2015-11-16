ec2_server:
  time_zone: Pacific/Auckland
  tms_server_domain_name: invenco-nz-stage.tms.invenco.com
  
  content_server_domain_name: 172.25.115.137
  
  # tomcat server private host-names(IPs) in AWS, these will be used in nginx load balancer
  tomcat_server_hosts:
    - 172.25.115.108
  
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
  enable_sslv2hello: False
    
tms:
  # tms2 web war
  tms_web_war: tms-web-1.1.4.war
  
  # tms2 REST api war
  tms_api_war: tms-api-2.0.16.war
  
  # tms-software
  tms_software_war: tms-software-2.0.11.war
  
  # tms-terminal-info
  tms_terminal_info_war: tms-terminal-info-2.0.9.war
  
  # ics-job
  ics_job_war: ics-job-1.1.10.war
  
  # ics-auth
  ics_auth_war: ics-auth-2.0.3.war
  
  # TMS war file to be deployed #
  tms_war: tms-webapp-1.1.4.war
  
  s3_bucket: invenco-nz-qa-tmsfiles-configuration-target

  #for site system, this is disabled
  enable_g6opt: True
  
  create_tms_test_user: True

  load_test_data: True

  #list of tms features to be disabled
  disabled_features:
    - CONFIGURATION
    - RELEASE
    
