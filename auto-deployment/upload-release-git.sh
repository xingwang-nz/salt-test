#! /bin/bash

# this script uploads ther release artifacts to git salt repository 
# and update the pillar file with latest release for test environment  

git_root_folder=/home/jenkins/build/tms-salt
test_env_pillar_file="${git_root_folder}/pillar/invenco-nz-test.sls"
artifact_release_folder="/home/jenkins/build/releases/target"

#git_root_folder=/home/xwang/temp/script/salt-test
#test_env_pillar_file="${git_root_folder}/pillar/ubuntu-salt-minion.sls"
#artifact_release_folder="/home/xwang/temp/script/release"

git_commit() {
	sleep 2
	cd "$git_root_folder"
	git add . --all
	sleep 2	
	git commit -m"auto commit from build machine"
	sleep 2
	git push
}

#echo "$(date +%x_%r): check war files in ${artifact_release_folder}"
if ls ${artifact_release_folder}/*.war > /dev/null 2>&1
then
   # syn local with git remote
   echo "$(date +%x_%r): found new release files, syn with git first"

   sleep 5 	
   cd "$git_root_folder"  
   git pull
   sleep 5

   counter=0
   ls ${artifact_release_folder}/*.war | while read FILE 
   do

	#extract filename from full file path
        filename="${FILE##*/}"
       	echo "$filename"

	#extract base filename from filenameh
        #filename_base_name="${filename%.*}"
        #echo "$filename_base_name"

	#delete shorest match from the back to '-'
	#e.g tms-web-2.0.26.war -> tms-web
	mudole_name=${filename%-*}

	#replace all "-" with "_", e.g tms-web - > tms_web
	mudole_name=${mudole_name//-/_}
	echo "$mudole_name"

	# for old webapp, the module name is "tms"
	if [ "$mudole_name" == "tms_webapp" ] 
		then mudole_name=tms
	fi
	
	mudole_line="  ${mudole_name}_war:"	
	echo "mudole_line: $mudole_line"
        
	new_module_line="${mudole_line} $filename"

	echo "new_mudole_line:  $new_module_line"

	#replace old module line with new module line
	sed -i "s/${mudole_line}.*/$new_module_line/" "$test_env_pillar_file"
	

	#move the new war file to git folder and comit the changes
	if mv "$FILE" "${git_root_folder}/state/deploy" 
		then echo "$FILE moved" 			      
	fi
   done  

   git_commit	
fi




