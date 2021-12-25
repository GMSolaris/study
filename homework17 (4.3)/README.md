1. Исправляем json
```
 {
 	"info": "Sample JSON output from our service\t",
 	"elements": [{
 		"name": "first",
 		"type": "server",
 		"ip": "7175"
 	}, {
 		"name": "second",
 		"type": "proxy",
 		"ip": "71.78 .22 .43"
 	}]
 }
```
 
 Если нет желания долго копаться в длинном jsone есть куча сервисов по валидации, которые быстро подскажут, где ошибка или отформатируют в красивый вид.
 Как приммер https://jsonformatter.org/
 
 2. В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: { "имя сервиса" : "его IP"}. Формат записи YAML по одному сервису: - имя сервиса: его IP. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.
Ваш скрипт:

```
#!/usr/bin/env python3

# import libs
import socket
import time
import datetime
import json
import yaml

# variables
i = 1
timeout = 2
host_list = {'api.mxgroup.ru': '0.0.0.0', 'new.mxgroup.ru': '0.0.0.0', 'm.mxgroup.ru': '0.0.0.0'}
init = 0

print("Script started")
print(host_list)

while 1 == 1:
    for host in host_list:
        ip = socket.gethostbyname(host)
        if ip != host_list[host]:
            if i == 1 and init != 0:
                print(str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")) + ' [ERROR] ' + str(
                    host) + ' IP mistmatch: ' + host_list[host] + ' ' + ip)
            host_list[host] = ip
    init += 1
    # json file save
    jsonString = json.dumps(host_list)
    jsonFile = open("services.json", "w")
    jsonFile.write(jsonString)
    jsonFile.close()
    # yaml file save
    with open('services.yaml', 'w') as file:
        yaml.dump(host_list, file, default_flow_style=False)
    time.sleep(timeout)
```

Вывод скрипта при запуске при тестировании:
```
Script started
{'api.mxgroup.ru': '0.0.0.0', 'new.mxgroup.ru': '0.0.0.0', 'm.mxgroup.ru': '0.0.0.0'}
```
и два файла 
```
- services.json ---> 
{"api.mxgroup.ru": "192.168.0.16", "new.mxgroup.ru": "192.168.0.16", "m.mxgroup.ru": "192.168.0.25"}
- services.yaml ---> 
api.mxgroup.ru: 192.168.0.16
m.mxgroup.ru: 192.168.0.25
new.mxgroup.ru: 192.168.0.16
```

3. Задание со *.
Конвертор написан на bash и использует в коде обращения к питону в виде процедур. 
Встроил проверку по расширению файла, так же присутствует контроль содержимого файла на валидность структуры json или yaml.
```
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

```

Вывод результата работы скрипта
```
kvazik@kvazik-matebook:/mnt/c/gmsolaris/study/homework17 (4.3)$ bash json_yaml_convertor.sh service.yaml
convert complete, result file ===> service.json
kvazik@kvazik-matebook:/mnt/c/gmsolaris/study/homework17 (4.3)$ bash json_yaml_convertor.sh services.json
convert complete, result file ===> services.yaml
kvazik@kvazik-matebook:/mnt/c/gmsolaris/study/homework17 (4.3)$ bash json_yaml_convertor.sh services_bad.json
Not valid json
kvazik@kvazik-matebook:/mnt/c/gmsolaris/study/homework17 (4.3)$ bash json_yaml_convertor.sh service_bad.yaml
Not valid yaml
kvazik@kvazik-matebook:/mnt/c/gmsolaris/study/homework17 (4.3)$ bash json_yaml_convertor.sh README.md
not yaml file
not json file
```