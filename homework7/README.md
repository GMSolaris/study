1. Команда cd это встроенная в оболочку команда buidin shell. Команда такая как и должна быть.
 Она используется для первоначальной навигации по папкам, для её вызова не должно быть никаких препятствий и дополнительно настроенных процедурных команд и тд. Команды встроенные в оболочку это фундамент терминала.

2. grep shell README.md выведет те строки, в которых  найдется искомое слово shell, в данный момент решения дз в файле README.md это одна строка.
```
myagkikh@KvaziK:/mnt/c/kvazik/study/homework7$ grep shell README.md
1. Команда cd это встроенная в оболочку команда buidin shell. Команда такая как и должна быть.    
```
Далее если использовать pipe и передать это в команду wc -l, которая считает кол-во строк в файле, то получим значение '1.'
В принципе конечно можно использовать такое выражение, но это относится к usless use. Гораздо проще заменить это конструкцией 
```
myagkikh@KvaziK:/mnt/c/kvazik/study/homework7$ grep -c shell README.md                                                  
1         
```
3. Поскольку привычнее всего пользоваться для работы с процессами утилитой htop опишу действия в ней. Процесс с pid 1 это процесс init.
 Это основной, первоначальный процесс, который запускает собственно всю остальную систему и процессы.
 Как видно ниже, все процессы идут потомками от первоначального, включая запущенный терминал под пользователем и запущенный в терминале htop.
```
  PID△USER      PRI  NI  VIRT   RES   SHR S CPU% MEM%   TIME+  Command
  1 root       20   0   900   528   464 S  0.0  0.0  0:00.01 /init
  6 root       20   0   900   528   464 S  0.0  0.0  0:00.00 ├─ /init
  7 root       20   0   900    84    20 S  0.0  0.0  0:00.00 └─ /init
  8 root       20   0   900    84    20 S  0.7  0.0  0:00.09    └─ /init
  9 myagkikh   20   0  7204  3864  3284 S  0.0  0.0  0:00.08       └─ -bash
  224 myagkikh   20   0  8084  4084  3424 R  0.0  0.0  0:00.05          └─ htop     
  ```
  
 4. Для тестирования данной задачи запустим дополнительный терминал. Для этого откроем еще одну сессию в powershell и прицепимся к нашему wsl debian. 
 ```
 PS C:\Windows\System32\WindowsPowerShell\v1.0> ssh myagkikh@172.18.184.107
 myagkikh@172.18.184.107's password:
 Linux KvaziK 5.10.16.3-microsoft-standard-WSL2 #1 SMP Fri Apr 2 22:23:49 UTC 2021 x86_64
 The programs included with the Debian GNU/Linux system are free software;
 the exact distribution terms for each program are described in the
 individual files in /usr/share/doc/*/copyright.
 Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
 permitted by applicable law.
```
Получим адрес нового терминала 
```
myagkikh@KvaziK:~$ tty
/dev/pts/1
```

Попробуем перенаправить команду вывода в наш новый терминал, для этого запустим ls с ошибочным параметром.
myagkikh@KvaziK:/mnt/c/kvazik/study$ ls --b 2>/dev/pts/1
На втором терминале видим вывод
```
myagkikh@KvaziK:~$ ls: option '--block-size' requires an argument
Try 'ls --help' for more information.          
```
5. Для вывода в файл stoud нужно дописать в команду >> путь к файлу. Для примера подачи на вход команды stdin и вывода её в файла запустим команду
wc -l README.md >> stout.log     
На выходе получим файл stout.log в котором содержится 
51 README.md

6. Не совсем понятно что имеется ввиду под графическим режимом. Если это запущенные X типа KDE, то вывести всю графическую оболочку и плюшки в TTY не получится.
 Терминал используется только для текстовых команд.
 Если речь идет про запущенный в KDE терминал PTY то вывести из него данные в любой другой файл\терминал не представляет проблем.
 
 7. bash 5>&1 данная создает файловый дескриптор под номером 5 и определяет его вывод в stdout. 
 Выполняя команду echo netology > /proc/$$/fd/5 мы получаем типовой stdout из 5 дескриптора в текущую консоль
 ```
 myagkikh@KvaziK:/mnt/c/kvazik/study/homework7$ echo netology > /proc/$$/fd/5
 netology    
 ```
 
 8. Для выполнение данной задачи придется использовать подмену дефолтных дескрипторов.
 Возьмем команду которая выводит и stdout и stderr. Для этого скомбинируем пару команд. Первая строка это stdout, две другие строки это stderr.
 ```
 kvazik@myagkikh:/mnt/c/gmsolaris/study/homework7$ (dir && ls ---ppp)
 README.md  error.log  out.log
 ls: unrecognized option '---ppp'
 Try 'ls --help' for more information.             
``` 
Теперь перенаправим вывод через подмену дескриптора. На выходе получим вывод в консоль stdout и передаем в pipe stderr где дальше через wc -l посчитаем кол-во переданных строк, их соответственно две. 
```
kvazik@myagkikh:/mnt/c/gmsolaris/study/homework7$ (dir && ls ---ppp) 3>&1 1>&2 2>&3 | wc -l
README.md  error.log  out.log
2   
```

9. Команда cat /proc/$$/environ выведет все переменные текущего окружения (запущенного терминала). Добиться такого же вывода можно командой env.

10. В файле "/proc/PID/cmdline" хранится командная строка, которая запустила данный процесс с указанным PID.
/proc/[pid]/cmdline
This holds the complete command line for the process, unless the process is a zombie.
In the latter case, there is nothing in this file: that is, a read on this file will return 0 characters.
The command-line arguments appear in this file as a set of strings separated by null bytes ('\0'), with a further null byte after the last string.

В файле "/proc/PID/exe" хранится симлинк на бинарник запущеной программы. 
/proc/[pid]/exe
Under Linux 2.2 and later, this file is a symbolic link containing the actual pathname of the executed command.
This symbolic link can be dereferenced normally; attempting to open it will open the executable.

11. Смотрим  cat /proc/cpuinfo | grep sse  
Процессор поддерживает sse sse2

12. Запуск команды ssh localhost 'tty' вызывает запуск команды tty по ssh на локальном сервере (разницы нет в принципе и в запуске на удаленном сервере, просто будет другой адрес вместо localhost).
При таком варианте запуска команды она выполняется не внутри терминала, соответственно я и получаю ошибку что это не терминал - not a tty
Для изменение такого поведения достаточно запустить команду ssh с ключом -t Команда выполнится с запуском удаленного терминала.
```
ssh -t localhost tty
kvazik@localhost's password:
/dev/pts/3                 
```

13. Попробовал перехватить запущенный в другой сессии редактор файла. Нашел процесс запущеный в другой сессии и его PID. 
Запустил новую консоль, ввел reptyr PID. Вышел из первой консоли, на второй получил запущенный редактор файла. 
В принципе работает.

14. При запуске команды sudo echo string > /root/new_file получим ошибку, так как sudo не перенаправляет stdout, соответственно команда echo выполнится без прав суперюзера. 
Для выполнения подобной операции надо воспользоваться командой tee, она записывает результат выполнения команды в файл и\или выводит в stdout. Через pipe запустим такую команду
echo string | sudo tee /root/new_file 
В данном случае мы сначала выполним команду echo string, далее stdout от неё передадим через pipe на запуск команде tee, которая запустится с правами суперюзера и уже она выполнит запись строки в файл.

