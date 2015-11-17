#! /bin/bash

# this script is configured to detect new version builds and invoke salt-run-states.s 
# to deploy new builds on TEST ENVIRONMENT, it runs in salt-master

git_root_folder="/home/xing/build-job/tms-salt"
test_env_pillar_file_name="invenco-nz-test.sls"
test_env_minion_id="ip-10-3-17-5.ap-southeast-2.compute.internal"



cd "$git_root_folder"

if git fetch && git log ..origin/master --stat | grep "$test_env_pillar_file_name" > /dev/null 2>&1; then
   echo "$(date +%x_%r):  $test_env_pillar_file_name changes, will launch salt-run-states.sh"
   git merge origin/master -m"auto merge" 
   sleep 10
   /srv/script/salt-run-states.sh "$test_env_minion_id"
fi 

