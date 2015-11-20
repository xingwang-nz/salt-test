#! /bin/bash

# this script is configured to detect new version ics-documentation swagger spec and deploy it to nginx

git_root_folder="/home/jobs/build-job/ics-documentation"

swagger_spec_file="tms.json"

nginx_deploy_folder="/usr/share/nginx/html/ics-api/swagger-spec"

cd "$git_root_folder"
echo "check swagger spec file"
if git fetch && git log ..origin/master --stat | grep "$swagger_spec_file" > /dev/null 2>&1; then
   echo "$(date +%x_%r):  $swagger_spec_file changes, will deploy to nginx folder"
   git merge origin/master -m"auto merge"
   sleep 10
   sudo cp "$git_root_folder/tms/swagger/${swagger_spec_file}"  $nginx_deploy_folder

fi