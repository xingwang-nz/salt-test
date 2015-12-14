***************Keycloak Bootstrapper *******
This jar has 4 main functions

  1) Change admin password

  2) Create realm and 1 client then output client key

  3) Create realm and 1 role

  4) Create user for a realm

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

2) Create realm and 1 client then output client key. Will also add CONFIG_ADMIN role if the type of client is ICS_SERVICE

Run by command:

java -cp ics-keycloak-bootstrap-0.0.1.jar com.invenco.ics.keycloak.main.KeycloakCreateClientLauncher "C:\Raj\temp\kcbootstrap.properties" "Test9Realm" "TMS_WEB" "https://invenco-nz-test.tms.invenco.com/tms-web" "https://invenco-nz-test.tms.invenco.com/auth"

 

There are 5 arguments

  arg[0]=Path to keycloak properties file

  arg[1]=Name of realm to create. Realm NOT created if it already exists

  arg[2]=Type of client to create. ["TMS_WEB" | "ICS_SERVICE"]

  arg[3]=Redirect URL. Url to Invenco tms-web

  arg[4]=keycloak server URL

 

***********************************************************************

3) Create realm and 1 role

Run by command:

java -cp ics-keycloak-bootstrap-0.0.1.jar com.invenco.ics.keycloak.main.KeycloakCreateRoleLauncher "C:\Raj\temp\kcbootstrap.properties" "Test9Realm" "RoleA"

 

There are 3 arguments

  arg[0]=Path to keycloak properties file

  arg[1]=Name of realm to create. Realm NOT created if it already exists

  arg[2]=Name of role to create.

 

 

***********************************************************************

4) Create a user for a realm

Run by command:

java -cp ics-keycloak-bootstrap-0.0.1.jar com.invenco.ics.keycloak.main.KeycloakCreateUserLauncher "C:\Raj\temp\kcbootstrap.properties" "Test9Realm" "UserName" "FirstName" "LastName" "Password" "Role"

 

There are 7 arguments

  arg[0]=Path to keycloak properties file

  arg[1]=Name of realm to to add user to

  arg[2]=User name of new user

  arg[3]=Firstname of new user

  arg[4]=Lastname of new user

  arg[5]=Password of new user

  arg[6]=Role of new user

***********************************************************************

 

 

Rajees Patel

Product Architect

Invenco Group Limited

O: +64 9 905 5673

Rajees.Patel@invenco.com

 

www.invenco.com

Disclaimer: This email is confidential and may be legally privileged.  If you are not the intended recipient you must not use any of the information in it and must delete the email immediately.



 
