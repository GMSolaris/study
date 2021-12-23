1. Есть скрипт:

#!/usr/bin/env python3
a = 1
b = '2'
c = a + b

c будет не поределено так как нельзя сложить две переменных с разными типами
Чтобы получить 12 нужно :
c=str(a)+b
Чтобы получить 3 нужно:
c=a+int(b)


2. Исправленный скрипт.
Убрал break, добавил вывод абсолютного пути до файла
```
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
path_to_file=(bash_command[0])
correct_path_to_file=path_to_file.replace("cd ", "")
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = os.path.expanduser(result.replace('\tmodified:   ', correct_path_to_file))
        print(prepare_result.replace('..', ''))
```		
```
{17:01}/mnt/c/GMSolaris/study/homework16 (4.2):master ✗ ➭ python3 git_mod.py
/home/kvazik/netology/sysadm-homeworks/1.sh
/home/kvazik/netology/sysadm-homeworks/test.py
```


3. Изменяем скрипт, на входе ждем директорию с локальным репозиторием git. Если это не реп, то выдаем ошибку.
```
#!/usr/bin/env python3

import os
import sys

input_path = sys.argv[1]


bash_command = ["cd "+input_path, "git status 2>&1"]
result_os = os.popen(' && '.join(bash_command)).read()


path_to_file=(bash_command[0])
correct_path_to_file=path_to_file.replace("cd ", "")
for result in result_os.split('\n'):
    if result.find('fatal') != -1:
        print('Not a git repository  ----> '+input_path)    
    if result.find('modified') != -1:
        prepare_result = os.path.expanduser(result.replace('\tmodified:   ', correct_path_to_file))
        print(prepare_result.replace('..', ''))
```

Вывод
``
{17:22}/mnt/c/GMSolaris/study/homework16 (4.2):master ✗ ➭ python3 git_mod.py /home/kvazik/
Not a git repository  ----> /home/kvazik/
{17:23}/mnt/c/GMSolaris/study/homework16 (4.2):master ✗ ➭ python3 git_mod.py /home/kvazik/netology/
/home/kvazik/netology/1.sh
/home/kvazik/netology/test.py
```

4. Скрипт проверки адреса хоста на изменение. В качестве хостов выбрал рабочие адреса, которые шейпятся через AWS route53. 
Соответствено довольно быстро начали отлавливаться изменения адресов, так как балансировщик выдает разные адреса в зависимости от загрузки того или иного хоста.
```
#!/usr/bin/env python3

import socket
import time
import datetime


i = 1
timeout = 2
host_list = {'api.mxgroup.ru':'0.0.0.0', 'new.mxgroup.ru':'0.0.0.0', 'm.mxgroup.ru':'0.0.0.0'}
init=0


print("Script started")
print(host_list)


while 1==1 : 
  for host in host_list:
    ip = socket.gethostbyname(host)
    if ip != host_list[host]:
      if i==1 and init !=0:
        print(str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")) +' [ERROR] ' + str(host) +' IP mistmatch: '+host_list[host]+' '+ip)
      host_list[host]=ip
  init+=1
  time.sleep(timeout)
```


 ```
 root@websiteplatform:~# python3 check_ip.py
Script started
{'api.mxgroup.ru': '0.0.0.0', 'new.mxgroup.ru': '0.0.0.0', 'm.mxgroup.ru': '0.0.0.0'}
2021-12-23 00:08:49 [ERROR] api.mxgroup.ru IP mistmatch: 86.102.120.103 109.126.14.134
2021-12-23 00:09:06 [ERROR] api.mxgroup.ru IP mistmatch: 109.126.14.134 86.102.120.103
2021-12-23 00:09:28 [ERROR] new.mxgroup.ru IP mistmatch: 109.126.14.134 213.87.100.172
```