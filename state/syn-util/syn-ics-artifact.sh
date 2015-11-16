#! /bin/bash
test_env_pillar_file=/home/xwang/temp/script/salt-test/pillar/ubuntu-salt-minion.sls

git_commit() {
	sleep 2
	cd /home/xwang/temp/script/salt-test    
	git add . --all
	sleep 2	
	git commit -m"auto commit from build machine"
	sleep 2
	git push
}

if ls /home/xwang/temp/script/build-wars/*.war > /dev/null 2>&1
then
   # syn local with git remote
   echo "found new artifact files, syn with git first"

   sleep 5 	
   cd /home/xwang/temp/script/salt-test    
   git pull
   sleep 5

   ls /home/xwang/temp/script/build-wars/*.war | while read FILE 
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

	# if old webapp, the module name is "tms"
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
	if mv "$FILE" /home/xwang/temp/script/salt-test/state/deploy	                     
		then echo "$FILE moved" 			      
	fi
   done
   
   git_commit	
fi



