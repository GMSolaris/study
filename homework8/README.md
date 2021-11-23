1. Запустим strace и перенаправим вывод stderr в файл, после чего грепнем файл на предмет cd. Получим строку отвечающую за старт данной команды из bash.
```
kvazik@kvazik-matebook:/mnt/c/GMSolaris/study/homework8$ strace /bin/bash -c 'cd /tmp' 2> strace_bash
kvazik@kvazik-matebook:/mnt/c/GMSolaris/study/homework8$ grep cd 'strace_bash'                                                                                                                                     
execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffd3a7514f0 /* 17 vars */) = 0
```

2. Запустим strace на команду file и выведем в файл 2> Далее грепнем файл и посмотрим какие файлы открывались при работе.
 Отбрасываем все что .so это библиотеки, а не базы.
 В /etc лежат дефолтные пустые файлики, видимо это доп настройки для magic, судя по описанию.
Остается /usr/share/misc/magic.mgc и /usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache
Последний запускается в режиме readonly смотрим что это, похоже ан кеш со списком модулей.
Значит наша база есть  /usr/share/misc/magic.mgc, откроем её текстовым редактором, похоже на базу.
Далее запустим гугл и удостоверимся что именно этот путь и есть наша искомая база.

openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libbz2.so.1.0", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY) = 3


3. Возьмем реальный пример. Хост на котором крутится nginx и пишет лог. Удалим лог, не останавливая сам nginx. Теперь грепнем файл лога.
```
root@ozprod6:/var/www/vhost/ozprod.mxgroup.ru/log# lsof | grep deleted | grep log
nginx     1892724                               root    6w      REG               8,17 2473020028    1048589 /var/www/vhost/ozprod.mxgroup.ru/log/api.access.log (deleted)
```
Файл довольно большой, но после удаления он не освободил место, так как nginx до сих пор пишет в него данные. Теперь попробуем его отправить в черную дыру.
```
root@ozprod6:/var/www/vhost/ozprod.mxgroup.ru/log# ls -l /proc/1892724/fd/6
l-wx------ 1 root root 64 ноя 21 06:00 /proc/1892724/fd/6 -> '/var/www/vhost/ozprod.mxgroup.ru/log/api.access.log (deleted)'
```
Отправляем в нулл наш удаленный файл.
```
root@ozprod6:/var/www/vhost/ozprod.mxgroup.ru/log# cat /dev/null > /proc/1892724/fd/6
```

После этого место на диске освобождается, а весь вывод из запущенного процесса уходит в дыру, или превращается ничего.

4. Процессы зомби не занимают CPU RA IO. но блокируют записи в таблице процессов, размер которой ограничен для каждого пользователя и системы в целом.
При достижении лимита записей все процессы пользователя, от имени которого выполняется создающий зомби родительский процесс,
не будут способны создавать новые дочерние процессы. Кроме этого, пользователь, от имени которого выполняется родительский процесс,
не сможет зайти на консоль (локальную или удалённую) или выполнить какие-либо команды на уже открытой консоли
(потому что для этого командный интерпретатор sh должен создать новый процесс).

5. Запустим утилиту opensnoop-bpfcc и посмотрим на вывод. Утилита трейсит все системные open() вызовы и файлы которые они открывают. 
На моем рабочем сервере картина такая:
```
PID    COMM               FD ERR PATH
1254   redis-server       21   0 /proc/1254/stat
1386   heartbeat          89   0 /proc/1386/status
1254   redis-server       21   0 /proc/1254/stat
1254   redis-server       21   0 /proc/1254/stat
1234   postgres_export     9   0 /proc/1234/stat
1234   postgres_export     9   0 /proc/stat
1234   postgres_export     9   0 /proc/1234/fd
1234   postgres_export     9   0 /proc/1234/limits
1777   postgres           35   0 pg_stat_tmp/global.stat
1356   postgres            3   0 pg_stat_tmp/global.tmp
1356   postgres            5   0 pg_stat_tmp/db_16401.tmp
1356   postgres            5   0 pg_stat_tmp/db_0.tmp
1777   postgres           35   0 pg_stat_tmp/global.stat
1777   postgres           35   0 pg_stat_tmp/global.stat
1777   postgres           39   0 pg_stat_tmp/db_16401.stat
1777   postgres           39   0 pg_stat_tmp/db_0.stat
1173080 zabbix_agentd       6   0 /var/log/zabbix-agent/zabbix_agentd.log
1173080 zabbix_agentd       6   0 /var/log/zabbix-agent/zabbix_agentd.log
1173080 zabbix_agentd       6   0 /proc/stat
1173080 zabbix_agentd       6   0 /var/log/zabbix-agent/zabbix_agentd.log
1173080 zabbix_agentd       6   0 /proc
1173080 zabbix_agentd       7   0 /proc/1/cmdline
1173080 zabbix_agentd       7   0 /proc/1/stat
```

6. uname -a использует системный вызов execve. Вот кусок мана по нему
EXECVE(2)                                                                                              
Linux Programmer's Manual                                                                                              
EXECVE(2)                                                                                                                                                                                                                                                   
NAME                                                                                                                                                                                                                                                
execve - execute program                                                                                                                                                                                                                                                                                                                                                                                                                                                           
SYNOPSIS                                                                                                                                                                                                                                            
#include <unistd.h>                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
int execve(const char *pathname, char *const argv[],                                                                                                                                                                                                    
char *const envp[]);                                                                                                                                                                                                                                                                                                                                                                                                                                                    
DESCRIPTION                                                                                                                                                                                                                                         
execve()  executes  the program referred to by pathname.  
This causes the program that is currently being run by the calling process to be replaced with a new program, 
with newly initialized stack, heap, and (initialized and uninitialized) data segments.        
Посмотреть вывод инфы через proc можно так
```$ cat /proc/version
Linux version 5.10.60.1-microsoft-standard-WSL2 (oe-user@oe-host) (x86_64-msft-linux-gcc (GCC) 9.3.0, GNU ld (GNU Binutils) 2.34.0.20200220) #1 SMP Wed Aug 25 23:20:18 UTC 2021   
```

7. Разница между ; и && в том, что в случае с ; вторая команда выполнится в любом случае,
а при использовании && вторая команда выполнится только в случае успешного выполнение первой (то есть если первая вернет exit code 0)
Если задать переменную set -e то при неудачном выполнении любой простой команды, кроме while if until ADN OR, шелл закроется. 
Фактически написанный скрипт в котором запускается несколько команд, без разницы как между собой соединенных, с таким условием при первой же неудачно выполненной команде остановится.

8. При определении set -euxo pipefail мы определяем что
 -e  Exit immediately if a command exits with a non-zero status.
 -u  Treat unset variables as an error when substituting.
 -x  Print commands and their arguments as they are executed.
 pipefail     the return value of a pipeline is the status of
                           the last command to exit with a non-zero status,
                           or zero if no command exited with a non-zero status
Фактически мы определяем что при запуске скрипта:
* если какая то команда завершается не с кодом 0 , то он завершается
* если используются неопределенные переменные, скрипт завершается
* все команды отображаются на экране по мере выполнения
* пайплайны завершаюются с кодом последней завершенной команды в трубе, если все команды завершились с кодом 0, то на выходе ноль.

9. Самые частые статусы процессов в системе это S    interruptible sleep (waiting for an event to complete)

Дополнительные буквы означают:
			   <    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
               +    is in the foreground process group