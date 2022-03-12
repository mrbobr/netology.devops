# Домашнее задание к занятию "6.3. MySQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.
>Версия сервера БД: 8.0.28 MySQL Community Server - GPL

```
mysql> \s
--------------
mysql  Ver 8.0.28-0ubuntu0.20.04.3 for Linux on x86_64 ((Ubuntu))

Connection id:		15
Current database:	
Current user:		root@172.20.0.1
SSL:			Cipher in use is TLS_AES_256_GCM_SHA384
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server version:		8.0.28 MySQL Community Server - GPL
Protocol version:	10
Connection:		127.0.0.1 via TCP/IP
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	utf8mb4
Conn.  characterset:	utf8mb4
TCP port:		3306
Binary data as:		Hexadecimal
Uptime:			28 min 5 sec

Threads: 2  Questions: 17  Slow queries: 0  Opens: 137  Flush tables: 3  Open tables: 56  Queries per second avg: 0.010
--------------
```

Подключитесь к восстановленной БД и получите список таблиц из этой БД.
> Одна таблица orders
```
mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| my_test_db         |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.00 sec)

mysql> use my_test_db
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed

mysql> show tables;
+----------------------+
| Tables_in_my_test_db |
+----------------------+
| orders               |
+----------------------+
1 row in set (0.01 sec)

```
**Приведите в ответе** количество записей с `price` > 300.
```
mysql> select * from orders where price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)
```
В следующих заданиях мы будем продолжать работу с данным контейнером.

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"
```
mysql> select user,host,plugin,password_lifetime,user_attributes from mysql.user where user='test';
+------+-----------+-----------------------+-------------------+-------------------------------------------------------------------------------------------------------------------------------------+
| user | host      | plugin                | password_lifetime | user_attributes                                                                                                                     |
+------+-----------+-----------------------+-------------------+-------------------------------------------------------------------------------------------------------------------------------------+
| test | localhost | mysql_native_password |               180 | {"metadata": {"fname": "James", "lname": "pretty"}, "Password_locking": {"failed_login_attempts": 3, "password_lock_time_days": 0}} |
+------+-----------+-----------------------+-------------------+-------------------------------------------------------------------------------------------------------------------------------------+

```
Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.
```
mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES where user = 'test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "pretty"} |
+------+-----------+---------------------------------------+
```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.
```
mysql> SELECT table_schema, table_name, engine FROM INFORMATION_SCHEMA.TABLES WHERE table_schema = 'my_test_db';
+--------------+------------+--------+
| TABLE_SCHEMA | TABLE_NAME | ENGINE |
+--------------+------------+--------+
| my_test_db   | orders     | InnoDB |
+--------------+------------+--------+
```
Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`
```
mysql> show profiles;
+----------+------------+---------------------------------------------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                                                           |
+----------+------------+---------------------------------------------------------------------------------------------------------------------------------+
|        1 | 0.00061400 | show engines                                                                                                                    |
|        2 | 0.00274550 | SELECT table_schema, table_name, engine FROM INFORMATION_SCHEMA.TABLES WHERE table_schema = 'my_test_db'                        |
|        3 | 0.03923175 | ALTER TABLE orders ENGINE = MyISAM                                                                                              |
|        4 | 0.00268125 | SELECT table_schema, table_name, engine FROM INFORMATION_SCHEMA.TABLES WHERE table_schema = 'my_test_db'                        |
|        5 | 0.08658025 | ALTER TABLE orders ENGINE = InnoDB                                                                                              |
|        6 | 0.00096875 | SELECT table_schema, table_name, engine FROM INFORMATION_SCHEMA.TABLES WHERE table_schema = 'my_test_db'                        |
+----------+------------+---------------------------------------------------------------------------------------------------------------------------------+
6 rows in set, 1 warning (0.01 sec)
```
> на MyISAM  `ALTER TABLE orders ENGINE = MyISAM` - 0.03923175s  
> на InnoDB  `ALTER TABLE orders ENGINE = InnoDB` - 0.03923175s 

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`:
> Количество памяти:
```
root@fd72657adcca:/etc/mysql# cat /proc/meminfo 
MemTotal:        2035232 kB
```
> my.cnf:
```
# Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

#
# The MySQL  Server configuration file.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Настройки согласно ТЗ
innodb_ﬂush_log_at_trx_commit = 2
innodb_file_per_table = ON
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 610M
innodb_log_ﬁle_size = 100M

# Custom config should go here
!includedir /etc/mysql/conf.d/
```
---