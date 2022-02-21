1. Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.
Приведите получившуюся команду или docker-compose манифест.

```
version: "3.1"
volumes:
 data:
 backup:

services:
  postgres:
    image: postgres:12
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

2. В БД из задачи 1:

- создайте пользователя test-admin-user и БД test_db
```
myagkikh@netology:~/hw6.2$ psql -h localhost -U netology
Пароль пользователя netology:
psql (13.5 (Debian 13.5-0+deb11u1), сервер 12.10 (Debian 12.10-1.pgdg110+1))
Введите "help", чтобы получить справку.

netology=# create user test_admin_user with encrypted password 'netology';
CREATE ROLE
netology=# CREATE DATABASE test_db;
CREATE DATABASE
```

- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
```sql
DROP TABLE IF EXISTS "clients";
DROP SEQUENCE IF EXISTS clients_id_seq;
CREATE SEQUENCE clients_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."clients" (
    "id" integer DEFAULT nextval('clients_id_seq') NOT NULL,
    "family" character varying(256) NOT NULL,
    "country" character varying(256) NOT NULL,
    "order" integer,
    CONSTRAINT "clients_pkey" PRIMARY KEY ("id")
) WITH (oids = false);

CREATE INDEX "clients_country" ON "public"."clients" USING btree ("country");


DROP TABLE IF EXISTS "orders";
DROP SEQUENCE IF EXISTS orders_id_seq;
CREATE SEQUENCE orders_id_seq INCREMENT 1 MINVALUE 1 MAXVALUE 2147483647 CACHE 1;

CREATE TABLE "public"."orders" (
    "id" integer DEFAULT nextval('orders_id_seq') NOT NULL,
    "name" character varying(1024) NOT NULL,
    "price" integer NOT NULL,
    CONSTRAINT "orders_pkey" PRIMARY KEY ("id")
) WITH (oids = false);


ALTER TABLE ONLY "public"."clients" ADD CONSTRAINT "clients_order_fkey" FOREIGN KEY ("order") REFERENCES orders(id) ON UPDATE CASCADE ON DELETE CASCADE NOT DEFERRABLE;
```

- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
```sql
GRANT ALL privileges on database test_db to test_admin_user;
GRANT ALL ON TABLE public.clients TO test_admin_user;
GRANT ALL ON TABLE public.orders TO test_admin_user;

```

- создайте пользователя test-simple-user
```
netology=# create user test_simple_user with encrypted password 'netology';
CREATE ROLE
```

- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db
```
GRANT UPDATE, INSERT, DELETE, SELECT ON TABLE public.clients TO test_simple_user;
GRANT UPDATE, INSERT, DELETE, SELECT ON TABLE public.orders TO test_simple_user;
```

Приведите:

- итоговый список БД после выполнения пунктов выше,
```
netology=# \l
                                     Список баз данных
    Имя    | Владелец | Кодировка | LC_COLLATE |  LC_CTYPE  |        Права доступа
-----------+----------+-----------+------------+------------+------------------------------
 netology  | netology | UTF8      | en_US.utf8 | en_US.utf8 |
 postgres  | netology | UTF8      | en_US.utf8 | en_US.utf8 |
 template0 | netology | UTF8      | en_US.utf8 | en_US.utf8 | =c/netology                 +
           |          |           |            |            | netology=CTc/netology
 template1 | netology | UTF8      | en_US.utf8 | en_US.utf8 | =c/netology                 +
           |          |           |            |            | netology=CTc/netology
 test_db   | netology | UTF8      | en_US.utf8 | en_US.utf8 | =Tc/netology                +
           |          |           |            |            | netology=CTc/netology       +
           |          |           |            |            | test_admin_user=CTc/netology
(5 строк)
```

- описание таблиц (describe)
```
netology-# \c test_db
psql (13.5 (Debian 13.5-0+deb11u1), сервер 12.10 (Debian 12.10-1.pgdg110+1))
Вы подключены к базе данных "test_db" как пользователь "netology".
test_db-# \d
                    Список отношений
 Схема  |      Имя       |        Тип         | Владелец
--------+----------------+--------------------+----------
 public | clients        | таблица            | netology
 public | clients_id_seq | последовательность | netology
 public | orders         | таблица            | netology
 public | orders_id_seq  | последовательность | netology
(4 строки)


test_db-# \d clients
                                            Таблица "public.clients"
 Столбец |          Тип           | Правило сортировки | Допустимость NULL |            По умолчанию
---------+------------------------+--------------------+-------------------+-------------------------------------
 id      | integer                |                    | not null          | nextval('clients_id_seq'::regclass)
 family  | character varying(256) |                    | not null          |
 country | character varying(256) |                    | not null          |
 order   | integer                |                    | not null          |
Индексы:
    "clients_pkey" PRIMARY KEY, btree (id)
    "clients_country" btree (country)
Ограничения внешнего ключа:
    "clients_order_fkey" FOREIGN KEY ("order") REFERENCES orders(id) ON UPDATE CASCADE ON DELETE CASCADE

test_db-# \d orders
                                             Таблица "public.orders"
 Столбец |           Тип           | Правило сортировки | Допустимость NULL |            По умолчанию
---------+-------------------------+--------------------+-------------------+------------------------------------
 id      | integer                 |                    | not null          | nextval('orders_id_seq'::regclass)
 name    | character varying(1024) |                    | not null          |
 price   | integer                 |                    | not null          |
Индексы:
    "orders_pkey" PRIMARY KEY, btree (id)
Ссылки извне:
    TABLE "clients" CONSTRAINT "clients_order_fkey" FOREIGN KEY ("order") REFERENCES orders(id) ON UPDATE CASCADE ON DELETE CASCADE
	
```

- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
```
test_db-# \dp
                                                  Права доступа
 Схема  |      Имя       |        Тип         |          Права доступа           | Права для столбцов | Политики
--------+----------------+--------------------+----------------------------------+--------------------+----------
 public | clients        | таблица            | netology=arwdDxt/netology       +|                    |
        |                |                    | test_simple_user=arwd/netology  +|                    |
        |                |                    | test_admin_user=arwdDxt/netology |                    |
 public | clients_id_seq | последовательность |                                  |                    |
 public | orders         | таблица            | netology=arwdDxt/netology       +|                    |
        |                |                    | test_simple_user=arwd/netology  +|                    |
        |                |                    | test_admin_user=arwdDxt/netology |                    |
 public | orders_id_seq  | последовательность |                                  |                    |
 
 ```
 
- список пользователей с правами над таблицами test_db
```
netology
test-admin-user
test-simple-user
```



3. Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders
```sql
BEGIN;
INSERT INTO "orders" ("name", "price") VALUES ('Шоколад', '10');
INSERT INTO "orders" ("name", "price") VALUES ('Принтер', '3000');
INSERT INTO "orders" ("name", "price") VALUES ('Книга', '500');
INSERT INTO "orders" ("name", "price") VALUES ('Монитор', '7000');
INSERT INTO "orders" ("name", "price") VALUES ('Гитара', '4000');
COMMIT;
```
Таблица clients
```sql
BEGIN;
INSERT INTO "clients" ("family", "country") VALUES ('Иванов Иван Иванович', 'USA');
INSERT INTO "clients" ("family", "country") VALUES ('Петров Петр Петрович', 'Canada');
INSERT INTO "clients" ("family", "country") VALUES ('Иоганн Себастьян Бах', 'Japan');
INSERT INTO "clients" ("family", "country") VALUES ('Ронни Джеймс Дио', 'Russia');
INSERT INTO "clients" ("family", "country") VALUES ('Ritchie Blackmore', 'Russia');
COMMIT;
```

Используя SQL синтаксис:

-    вычислите количество записей для каждой таблицы
-    приведите в ответе:
        запросы
        результаты их выполнения.

```
test_db=# select count(*) from orders;
 count
-------
     5

test_db=# select count(*) from clients;
 count
-------
     5
```

4. Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

```sql
update clients set "order"=3 where family='Иванов Иван Иванович';
update clients set "order"=4 where family='Петров Петр Петрович';
update clients set "order"=5 where family='Иоганн Себастьян Бах';
```
Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
```sql
select 
clients.id as "Номер клиента",
clients.family as "Наименование клиента",
orders.name as "Наименование товара",
orders.price as "Цена товара"
from clients left join orders on clients.order=orders.id 
where clients.order is not null

Иванов Иван Иванович	Книга	500
Петров Петр Петрович	Монитор	7000
Иоганн Себастьян Бах	Гитара	4000
```

5. Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).
Приведите получившийся результат и объясните что значат полученные значения.
```sql
explain (FORMAT JSON)
select 
clients.id as "Номер клиента",
clients.family as "Наименование клиента",
orders.name as "Наименование товара",
orders.price as "Цена товара"
from clients left join orders on clients.order=orders.id 
where clients.order is not null
```

```json
[
  {
    "Plan": {
      "Node Type": "Hash Join",
      "Parallel Aware": false,
      "Join Type": "Right",
      "Startup Cost": 11.57,
      "Total Cost": 24.20,
      "Plan Rows": 70,
      "Plan Width": 1040,
      "Inner Unique": false,
      "Hash Cond": "(orders.id = clients.\"order\")",
      "Plans": [
        {
          "Node Type": "Seq Scan",
          "Parent Relationship": "Outer",
          "Parallel Aware": false,
          "Relation Name": "orders",
          "Alias": "orders",
          "Startup Cost": 0.00,
          "Total Cost": 11.40,
          "Plan Rows": 140,
          "Plan Width": 524
        },
        {
          "Node Type": "Hash",
          "Parent Relationship": "Inner",
          "Parallel Aware": false,
          "Startup Cost": 10.70,
          "Total Cost": 10.70,
          "Plan Rows": 70,
          "Plan Width": 524,
          "Plans": [
            {
              "Node Type": "Seq Scan",
              "Parent Relationship": "Outer",
              "Parallel Aware": false,
              "Relation Name": "clients",
              "Alias": "clients",
              "Startup Cost": 0.00,
              "Total Cost": 10.70,
              "Plan Rows": 70,
              "Plan Width": 524,
              "Filter": "(\"order\" IS NOT NULL)"
            }
          ]
        }
      ]
    }
  }
]
```
Вывод направил в JSON так удобнее читать результат. 

Эта команда выводит план выполнения, генерируемый планировщиком PostgreSQL для заданного оператора. План выполнения показывает, как будут сканироваться таблицы, затрагиваемые оператором — просто последовательно, по индексу и т. д. — а если запрос связывает несколько таблиц, какой алгоритм соединения будет выбран для объединения считанных из них строк.

Наибольший интерес в выводимой информации представляет ожидаемая стоимость выполнения оператора, которая показывает, сколько, по мнению планировщика, будет выполняться этот оператор (это значение измеряется в единицах стоимости, которые не имеют точного определения, но обычно это обращение к странице на диске). Фактически выводятся два числа: стоимость запуска до выдачи первой строки и общая стоимость выдачи всех строк.

Если своими словами, то удобный инструмент для дебага запросов, вычисления узких мест и оптимизации плана выполнения.
Используется для ускорения запросов.

6. Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).
```
pg_dump test_db > /var/lib/postgresql/backup/backup.sql
```

Остановите контейнер с PostgreSQL (но не удаляйте volumes).
```
myagkikh@netology:~/hw6.2$ sudo docker-compose stop
Stopping hw62_postgres_1 ... done
```

Поднимите новый пустой контейнер с PostgreSQL.
```
myagkikh@netology:~/hw6.2/pg_2$ sudo docker-compose up -d
Starting pg_2_postgres_1 ... done
```


Восстановите БД test_db в новом контейнере.
```
psql -U netology template1 -c 'create database test_db with owner netology'
psql -U netology test_db < /var/lib/postgresql/backup/backup.sql
```

Приведите список операций, который вы применяли для бэкапа данных и восстановления.

