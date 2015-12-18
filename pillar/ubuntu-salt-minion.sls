realms:
  demo:
    domain_name: 172.25.110.94
    content_server_doamin_name: 172.25.110.94
    users:
      testuser1:
        password: Password1
        first_name: Xing
        last_name: Wang
        role: CONFIG_ADMIN 
  TestRealmOne:
    domain_name: invenco-nz-stage.tms.invenco.com
    content_server_doamin_name: invenco-nz-stage-content.tms.invenco.com
  TestRealmTwo:
    domain_name: invenco-nz-stage.tms.invenco.com
    content_server_doamin_name: invenco-nz-stage2-content.tms.invenco.com

keycloak_server:
#  domain_name: 172.25.110.14
  host: 172.25.120.6
  port: 8080
  admin:
    username: admin
    password: Password1

    
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
      
tms_db:
  host: 172.25.110.97
  port: 5432
  dbname: tms_server_db
  keycloak_dbname: keycloak
    
ssl: 
  protocols:
    - TLSv1
    - TLSv1.1
    - TLSv1.2
  enable_sslv2hello: False
    
tms:
  # tms2 web war
  tms_web_war: tms-web-1.1.9.war
  
  # tms2 REST api war
  tms_api_war: tms-api-2.0.16.war
  
  # tms-software
  tms_software_war: tms-software-2.0.11.war
  
  # tms-terminal-info
  tms_terminal_info_war: tms-terminal-info-2.0.9.war
  
  # ics-job
  ics_job_war: ics-job-1.1.5.war
  
  # ics-auth
  ics_auth_war: ics-auth-2.0.3.war
  
  # TMS war file to be deployed #
  tms_war: tms-webapp-1.1.9.war
  
  s3_bucket: invenco-nz-qa-tmsfiles-configuration-target

  #for site system, this is disabled
  enable_g6opt: True
  
  create_tms_test_user: True

  load_test_data: True

  #list of tms features to be disabled
  disabled_features:
    - CONFIGURATION
    - RELEASE
    
