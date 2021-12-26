# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательная задача 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:
| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | не определено  |
| Как получить для переменной `c` значение 12?  | c=str(a)+b |
| Как получить для переменной `c` значение 3?  | c=a+int(b)  |

## Обязательная задача 2
Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
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

### Вывод скрипта при запуске при тестировании:
```
{17:01}/mnt/c/GMSolaris/study/homework16 (4.2):master ✗ ➭ python3 git_mod.py
/home/kvazik/netology/sysadm-homeworks/1.sh
/home/kvazik/netology/sysadm-homeworks/test.py
```

## Обязательная задача 3
1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
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

### Вывод скрипта при запуске при тестировании:
```
{17:22}/mnt/c/GMSolaris/study/homework16 (4.2):master ✗ ➭ python3 git_mod.py /home/kvazik/
Not a git repository  ----> /home/kvazik/
{17:23}/mnt/c/GMSolaris/study/homework16 (4.2):master ✗ ➭ python3 git_mod.py /home/kvazik/netology/
/home/kvazik/netology/1.sh
/home/kvazik/netology/test.py
```

## Обязательная задача 4
1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
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

### Вывод скрипта при запуске при тестировании:
```
 root@websiteplatform:~# python3 check_ip.py
Script started
{'api.mxgroup.ru': '0.0.0.0', 'new.mxgroup.ru': '0.0.0.0', 'm.mxgroup.ru': '0.0.0.0'}
2021-12-23 00:08:49 [ERROR] api.mxgroup.ru IP mistmatch: 86.102.120.103 109.126.14.134
2021-12-23 00:09:06 [ERROR] api.mxgroup.ru IP mistmatch: 109.126.14.134 86.102.120.103
2021-12-23 00:09:28 [ERROR] new.mxgroup.ru IP mistmatch: 109.126.14.134 213.87.100.172
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. С директорией локального репозитория можно делать всё, что угодно. Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 

### Ваш скрипт:
```python
???
```

### Вывод скрипта при запуске при тестировании:
```
???
```