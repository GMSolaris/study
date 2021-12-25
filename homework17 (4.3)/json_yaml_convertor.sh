#!/usr/bin/env bash



function yaml_validate {
  python3 -c 'import sys, yaml, json; yaml.safe_load(sys.stdin.read())'  2> yaml_validate_result
}

function yaml2json {
  python3 -c 'import sys, yaml, json; print(json.dumps(yaml.safe_load(sys.stdin.read())))' 2> /dev/null
}

function json_validate {
  python3 -c 'import sys, yaml, json; json.loads(sys.stdin.read())' 2> json_validate_result
}

function json2yaml {
  python3 -c 'import sys, yaml, json; print(yaml.dump(json.loads(sys.stdin.read())))' 2> /dev/null
}

file_name=$1
cat $file_name | json_validate 
cat $file_name | yaml_validate
json_state=$(grep json_validate_result -e 'Error' | tail -1 | wc -l)
yaml_state=$(grep yaml_validate_result -e 'Error' | tail -1 | wc -l)
if [[ "$file_name" == *.json ]]
then
			if (( json_state == 1 ))
			then
					echo "Not valid json"
					rm json_validate_resul &>/dev/null
					exit 1
			else 
				check_ext_json=2	
			fi
else 
				if [[ "$file_name" == *.yaml ]] 
				then
						if (( yaml_state == 1 ))
						then
							echo "Not valid yaml"
							rm yaml_validate_result &>/dev/null
							exit 1
						else
						check_ext_yaml=2		
						fi	
				else
					echo "not yaml file"
				fi		

		if [[ "$file_name" == *.yaml ]] 
		then 
			abc=123
		else
			echo "not json file"
		fi
fi	
	
	
		
		
if 	(( check_ext_json == 2 ))	
	then 
	  cat $file_name | json2yaml > ${file_name/json/yaml}
	  echo "convert complete, result file ===> ${file_name/json/yaml}"
	fi
	  
		
if 	(( check_ext_yaml == 2 ))	
	then 
	  cat $file_name | yaml2json > ${file_name/yaml/json}
	  echo "convert complete, result file ===> ${file_name/yaml/json}"
	fi
rm yaml_validate_result &>/dev/null
rm json_validate_resul &>/dev/null