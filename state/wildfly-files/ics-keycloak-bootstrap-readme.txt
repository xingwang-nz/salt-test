***************Keycloak Bootstrapper *******
This jar has 4 main functions

  1) Change admin password
  
  2) Create realm and 1 client then output client key

  3) Create user for a realm

*********************************************************************** 

1)Change admin password

Run by command:

java -cp ics-keycloak-bootstrap-0.0.1.jar com.invenco.ics.keycloak.main.KeycloakChangePasswordLauncher "http://localhost:8180/auth" admin Fyp3f*UyS@ Fyp3f*UyS@ "security-admin-console"

 

There are 5 arguments

  arg[0]=Url to keycloak service

  arg[1]=Admin username

  arg[2]=Current admin password

  arg[3]=New admin password

  arg[4]=id of client that will be used to get direct access token

 
***********************************************************************

2) Create realm and 1 client then output client key. Will also add CONFIG_ADMIN role if the type of client is ICS_SERVICE

Run by command:

java -cp ics-keycloak-bootstrap-0.0.1.jar com.invenco.ics.keycloak.main.KeycloakCreateClientLauncher "C:\Raj\temp\kcbootstrap.properties"  "<admin-user>" "<admin-password>" "Test9Realm" "TMS_WEB" "https://invenco-nz-test.tms.invenco.com/tms-web" "https://invenco-nz-test.tms.invenco.com/auth"
 

There are 7 arguments

  arg[0]=Path to keycloak properties file
  
  arg[1]=Master admin username
  
  arg[2]=Master admin password

  arg[3]=Name of realm to create. Realm NOT created if it already exists

  arg[4]=Type of client to create. ["TMS_WEB" | "ICS_SERVICE"]
  
  arg[5]=keycloak server URL - used in keycloak.jason

  arg[6]=Redirect URL. Url to Invenco tms-web

 

***********************************************************************
3) Create a user for a realm

Run by command:

java -cp ics-keycloak-bootstrap-0.0.1.jar com.invenco.ics.keycloak.main.KeycloakCreateUserLauncher "C:\Raj\temp\kcbootstrap.properties" "<admin-user>" "<admin-password>" "Test9Realm" "UserName" "FirstName" "LastName" "Password" "Role"


There are 9 arguments

  arg[0]=Path to keycloak properties file

  arg[1]=Master admin username
  
  arg[2]=Master admin password
  
  arg[3]=Name of realm to to add user to

  arg[4]=User name of new user
  
  arg[5]=Password of new user

  arg[6]=Firstname of new user

  arg[7]=Lastname of new user

  arg[8]=Role of new user, optional

***********************************************************************


