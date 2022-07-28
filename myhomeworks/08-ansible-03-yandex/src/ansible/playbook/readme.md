---
## Описание playbook

### 1. Директории  
- group_vars - содержит переменные для групп хостов clickhouse, vector, lighthouse
- inventory - содержит файл prod.yml с описанием управляемых хостов. Генерируется автоматически посредством terraform (в процессе создания подставляются актуальные IP созданных хостов).
- templates - содержит шаблоны файлов конфигураций для vector, nginx и lighthouse. Параметризованы с использованием переменных из group_vars.
### 2. Файлы
- ansible.cfg - содержит параметр `host_key_checking = False` позволяющий не вводить подтверждение при первичном подключении к новому хосту
- clickhouse.yml, lighthouse.yml, vector.yml - содержат соответствующие play для установки сервисов. Для установки можно использовать тэги cliсkhouse, vector, lighthouse, nginx, git

### 3. Plays

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

#### Install vector

Список tasks:
- `Create vector group` - создает группу ОС vector
- `Create vector user` - создает пользователя ОС vector
- `Create vector dirs` - создает директории для скачивания, установки и данных vector. Полные пути указываются в переменных в файле group_vars/vector/vars.yml
- `Install Vector` - скачивает дистрибутив и устанавливает vector в указанную директорию. Версия указывается в переменной в файле group_vars/vector/vars.yml
- `Vector config` - помещает в указанную в переменных директорию конфигурационный файл vector.toml. Этот файл используется в конфигурационном файле vector.service.
- `Create Vector service` - помещает в системную директорию файл vector.system для запуска vector, как сервиса systemd.
- `Start Vector service` - запускает сервис vector

#### Install lighthouse
Список handlers
- `start nginx` - запускает nginx
- `restart nginx` - перезапускает nginx (в случае изменения конфигурационных файлов)

Список pre_tasks:
- `Install epel-release` - устанавливает репозиторий epel-release для последующей установки nginx
- `Install nginx` - устанавливает nginx (необходим для работы lighthouse). Вызывает хэндлер для запуска nginx.
- `Install git` - устанавливает vcs git (необходим для получения дистрибутива lighthouse)

Список tasks:
- `Install lighthouse` - скачивает lighthouse посредством git в указанную в переменных директорию
- `Config nginx` - размещает конфигурационный файл nginx.conf для настройки nginx. Вызывает хэндлер для перезапуска nginx.
- `Config lighthouse` - размещает конфигурационный файл в директорию nginx/conf.d для настройки сервера lighthouse. Вызывает хэндлер для перезапуска nginx.
---
## Использование Terraform
1. Перейти в директорию terraform и выполнить 'terraform init'
2. Для создания своего образа ВМ в YC можно воспользоваться утилитой [packer](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/packer-quickstart)
3. Предварительно добавить используемые для YC переменные окружения (подробнее см. файл [variables.tf](../../terraform/variables.tf))
4. Для создания ВМ без настройки необходимо выполнить `terraform plan` и `terraform apply`. После создания выводятся внутренние и публичные IP созданных хостов. В директории ./ansible/playbook/inventory сформируется файл prod.yml по шаблону [inventory.tf](../../terraform/inventory.tf)
5. Для создания ВМ и их последующей автоматической настройки с помощью ansible необходимо копировать файлы ansible.cfg и ansible.tf из директории automate_ansible в директорию terraform и выполнить команды из п.4
---

