***************Keycloak Bootstrapper *******
This jar has 2 main functions
  1) Change admin password
  2) Create realm and 1 client then output client key
  
---------------------------------------------------------------  
1)Change admin password
Run by command: 
java -cp ics-keycloak-bootstrap-0.0.1.jar com.invenco.ics.keycloak.main.KeycloakChangePasswordLauncher "http://localhost:8180/auth" admin Fyp3f*UyS@ Fyp3f*UyS@ "security-admin-console"

There are 5 arguments
  arg[0]=Url to keycloak service
  arg[1]=Admin username
  arg[2]=Current admin password
  arg[3]=New admin password
  arg[4]=id of client that will be used to get direct access token 

---------------------------------------------------------------
2) Create realm and 1 client then output client key
Run by command:
java -cp ics-keycloak-bootstrap-0.0.1.jar com.invenco.ics.keycloak.main.KeycloakBootstrapLauncher "C:\Raj\temp\kcbootstrap.properties" "Test9Realm" "tms-web"

There are 3 arguments
  arg[0]=Path to keycloak properties file
  arg[1]=Name of realm to create
  arg[2]=Type of client to create. ["tms-web" | "ics-service"]

***********************************************************************
