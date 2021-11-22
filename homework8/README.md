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

5. 