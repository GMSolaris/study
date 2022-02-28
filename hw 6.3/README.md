1. 
- Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.
```yaml
version: '3.1'

services:

  db:
    image: mariadb
    restart: always
    environment:
      MARIADB_ROOT_PASSWORD: root
    volumes:
      - ./mysql:/var/lib/mysql
  adminer:
    image: adminer
    restart: always
    ports:
      - 8080:8080
```


- Изучите бэкап БД и восстановитесь из него.
```
MariaDB [(none)]> create database test_db;
Query OK, 1 row affected (0.000 sec)

myagkikh@netology:~/hw6.3$ mysql -uroot -h 127.0.0.1 -p test_db < dump.sql
Enter password:
```
Поскольку использую марусю, то пришлось поменять collation на utf8mb4_unicode_ci.


- Перейдите в управляющую консоль mysql внутри контейнера.
```
myagkikh@netology:~/hw6.3$ sudo docker exec -it hw63_db_1 /bin/bash
root@3bc9df23f4f9:/#
```

- Используя команду \h получите список управляющих команд.
```
root@3bc9df23f4f9:/# mysql -p
Enter password:
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 15
Server version: 10.7.3-MariaDB-1:10.7.3+maria~focal mariadb.org binary distribution

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> \h

General information about MariaDB can be found at
http://mariadb.org

List of all client commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to MariaDB server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to MariaDB server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.

For server side help, type 'help contents'
```

- Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД.
```
MariaDB [(none)]> \s
--------------
mysql  Ver 15.1 Distrib 10.7.3-MariaDB, for debian-linux-gnu (x86_64) using readline 5.2

Connection id:          16
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server:                 MariaDB
Server version:         10.7.3-MariaDB-1:10.7.3+maria~focal mariadb.org binary distribution
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /run/mysqld/mysqld.sock
Uptime:                 18 min 19 sec

Threads: 1  Questions: 64  Slow queries: 0  Opens: 21  Open tables: 13  Queries per second avg: 0.058
--------------
```

- Подключитесь к восстановленной БД и получите список таблиц из этой БД.
```
MariaDB [(none)]> use test_db;

MariaDB [test_db]> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.000 sec)
```


Приведите в ответе количество записей с price > 300.
```
MariaDB [test_db]> select count(*) from orders where price > 300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.000 sec)
```

2. Создайте пользователя test в БД c паролем test-pass, используя:

плагин авторизации mysql_native_password
срок истечения пароля - 180 дней
количество попыток авторизации - 3
максимальное количество запросов в час - 100
аттрибуты пользователя:
Фамилия "Pretty"
Имя "James"

```
mysql> CREATE USER 'test'@'localhost' IDENTIFIED BY 'test-pass';
Query OK, 0 rows affected (0.22 sec)

mysql> 
mysql> ALTER USER 'test'@'localhost' ATTRIBUTE '{"fname":"James", "lname":"Pretty"}';
Query OK, 0 rows affected (0.16 sec)

mysql> 
mysql> ALTER USER 'test'@'localhost' 
    -> IDENTIFIED BY 'test-pass' 
    -> WITH
    -> MAX_QUERIES_PER_HOUR 100
    -> PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2;
Query OK, 0 rows affected (0.12 sec)

mysql> 
mysql> GRANT Select ON test_db.orders TO 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.14 sec)
```

Выполнял этот кусок в обычном MySQL, почему то маруся ругается. Хотелось бы подсказки почему? Нет такого функционала?
```
MariaDB [test_db]> ALTER USER 'test'@'localhost' ATTRIBUTE '{"fname":"James", "lname":"Pretty"}';
ERROR 1064 (42000): You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near 'ATTRIBUTE '{"fname":"James", "lname":"Pretty"}'' at line 1
```

3. Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES;.
Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.
Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:
- на MyISAM
- на InnoDB
```
MariaDB [test_db]> SELECT TABLE_NAME,ENGINE,ROW_FORMAT,TABLE_ROWS,DATA_LENGTH,INDEX_LENGTH FROM information_schema.TABLES WHERE table_name = 'orders' and  TABLE_SCHEMA = 'test_db' ORDER BY ENGINE asc;
+------------+--------+------------+------------+-------------+--------------+
| TABLE_NAME | ENGINE | ROW_FORMAT | TABLE_ROWS | DATA_LENGTH | INDEX_LENGTH |
+------------+--------+------------+------------+-------------+--------------+
| orders     | InnoDB | Dynamic    |          5 |       16384 |            0 |
+------------+--------+------------+------------+-------------+--------------+
1 row in set (0.000 sec)

MariaDB [test_db]> set profiling = 1;
Query OK, 0 rows affected (0.000 sec)

MariaDB [test_db]> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.015 sec)
Records: 5  Duplicates: 0  Warnings: 0

MariaDB [test_db]> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.019 sec)
Records: 5  Duplicates: 0  Warnings: 0

MariaDB [test_db]> show profiles;
+----------+------------+------------------------------------+
| Query_ID | Duration   | Query                              |
+----------+------------+------------------------------------+
|        1 | 0.01483075 | ALTER TABLE orders ENGINE = MyISAM |
|        2 | 0.01860382 | ALTER TABLE orders ENGINE = InnoDB |
+----------+------------+------------------------------------+
2 rows in set (0.000 sec)
```

4. Изучите файл my.cnf в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):

Скорость IO важнее сохранности данных - innodb_flush_log_at_trx_commit = 0 
Нужна компрессия таблиц для экономии места на диске - innodb_file_format=Barracuda
Размер буффера с незакомиченными транзакциями 1 Мб - innodb_log_buffer_size	= 1M
Буффер кеширования 30% от ОЗУ - key_buffer_size = 600М
Размер файла логов операций 100 Мб - max_binlog_size	= 100M
Приведите в ответе измененный файл my.cnf.
```
[mysqld]
innodb_flush_log_at_trx_commit = 0 
innodb_file_format=Barracuda
innodb_log_buffer_size	= 1M
key_buffer_size = 640М
max_binlog_size	= 100M
```





