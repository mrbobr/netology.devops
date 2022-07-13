## Описание playbook

### 1. Директории  
- group_vars - содержит переменные для двух групп хостов clickhouse и vector
- inventory - содержит файл prod.yml с описанием управляемых хостов
- templates - содержит файл конфига vector
### 2. Файл site.yml  
содержит два play для установки clickhouse и vector:

#### Install Clickhouse  
Список handlers
- `Start clickhouse service` для запуска clickhouse после установки

Список tasks:
- `Create clickhouse temp dir` - создает директорию для скачивания дистрибутивов. Полный путь указывается в переменной clickhouse_tmp_dir
- `Get clickhouse distrib *.noarch.rpm` - скачивает пакеты для установки. Список и версия пакетов указываются в переменных clickhouse_packages и clickhouse_version.
- `Get clickhouse-common-static.version.x86_64.rpm` - скачивает пакет *.x86_64.rpm в случае отсутствия *.noarch.rpm. Запускается только при неуспешном выполнении предыдущей task.
- `Install clickhouse packages` - устанавливает скачанные пакеты с помощью пакетного менеджера yum. После успешного выполнения вызывает handler для запуска clickhouse.

Список post_task:
- `Create database` - создает в clickhouse базу данных logs. Выделена в post_tasks для гарантированного выполнения после запуска хэндлера `Start clickhouse service` 

Для выполнения только этих задач можно использовать тэг `clickhouse`

#### Install vector
Список handlers
- `Start vector` выполняет запуск vector из командной оболочки

Список tasks:
- `Create vector group` - создает группу ОС vector
- `Create vector user` - создает пользователя ОС vector
- `Create vector dirs` - создает директории для скачивания, установки и данных vector. Полные пути указываются в переменных в файле group_vars/vector/vars.yml
- `Get vector distrib` - скачивает дистрибутив vector в указанную директорию. Версия указывается в переменной в файле group_vars/vector/vars.yml
- `Extract Vector` - распаковывает скачанный архив в рабочую директорию vector. Выполняется только если предыдущее задание было со статусом changed.
- `Put vector config` - помещает преднастроенный конфигурационный файл vector.toml (путь указывается в файле group_vars/vector/vars.yml) в папку с конфигами рабочей директории.  Выполняет вызов хэндлера `Start vector`

Для выполнения только этих задач можно использовать тэг `vector`


