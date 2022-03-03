1. 
- Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
```yml
version: "3.1"
volumes:
 data:
 backup:

services:
  postgres:
    image: postgres
    environment:
      POSTGRES_DB: "netology"
      POSTGRES_USER: "netology"
      POSTGRES_PASSWORD: "netology"
    volumes:
      - ./data:/var/lib/postgresql/data
      - ./backup:/var/lib/postgresql/backup
    ports:
      - "5432:5432"
```

- Подключитесь к БД PostgreSQL используя psql.
```
myagkikh@netology:~/hw6.4$ psql -h localhost -U netology
Пароль пользователя netology:
```


Воспользуйтесь командой \? для вывода подсказки по имеющимся в psql управляющим командам.


Найдите и приведите управляющие команды для:

- вывода списка БД
```
netology=# \l
                                 Список баз данных
    Имя    | Владелец | Кодировка | LC_COLLATE |  LC_CTYPE  |     Права доступа
-----------+----------+-----------+------------+------------+-----------------------
 netology  | netology | UTF8      | en_US.utf8 | en_US.utf8 |
 postgres  | netology | UTF8      | en_US.utf8 | en_US.utf8 |
 template0 | netology | UTF8      | en_US.utf8 | en_US.utf8 | =c/netology          +
           |          |           |            |            | netology=CTc/netology
 template1 | netology | UTF8      | en_US.utf8 | en_US.utf8 | =c/netology          +
           |          |           |            |            | netology=CTc/netology
(4 строки)
```
- подключения к БД
```
netology=# \c postgres
Вы подключены к базе данных "postgres" как пользователь "netology".
```

- вывода списка таблиц
```
postgres=# \d
```

вывода описания содержимого таблиц
```
\d table_name
```

- выхода из psql
```
CTRL+D - стандартный выход в линуксе из любой консоли
Либо \q
```

2. 
- Используя psql создайте БД test_database.
```
netology=# CREATE DATABASE test_database;
CREATE DATABASE
```
Изучите бэкап БД.
Восстановите бэкап БД в test_database.
Перейдите в управляющую консоль psql внутри контейнера.
```
postgres@5980fccc7001:/$  psql -U netology test_database < /var/lib/postgresql/backup/dump.sql
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)
```
Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.
Приведите в ответе команду, которую вы использовали для вычисления и полученный результат.
```
postgres@5980fccc7001:/$ psql
psql (14.2 (Debian 14.2-1.pgdg110+1))
Type "help" for help.

postgres=# \c test_database
You are now connected to database "test_database" as user "postgres".
test_database=# ANALYZE;
ANALYZE

test_database=# select avg_width from pg_stats where tablename='orders';
 avg_width
-----------
         4
        16
         4
(3 rows)
```


3. 
Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
Исключить ручное разбиение можно было создав изначально секционную таблицу, определив границы секций, чтобы записи сами распределялись по секциям.
```
test_database=# alter table orders rename to orders_old;
ALTER TABLE
test_database=# create table orders (id integer, title varchar(80), price integer) partition by range(price);
CREATE TABLE
test_database=# create table orders_1 partition of orders for values from (0) to (499);
CREATE TABLE
test_database=# create table orders_2 partition of orders for values from (499) to (MAXVALUE);
CREATE TABLE
test_database=# insert into orders (id, title, price) select * from orders_old;
INSERT 0 8
```

4. Используя утилиту pg_dump создайте бекап БД test_database.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?

root@5980fccc7001:/# pg_dump -U postgres -d test_database > /var/lib/postgresql/backup/dump2.sql

Добратал дамп. Во-первых неплохо бы добавить индекс на поле id, так как зачастую именно это поле будет использоваться для всех видов селектов и джоинов. Плюс его стоит сделать первичным ключом. 
А поле title уникальным. 
```sql
CREATE TABLE public.orders (
    id integer PRIMARY KEY,
    title character varying(80),
    price integer,
	UNIQUE (id,title)
)
PARTITION BY RANGE (price);
```


