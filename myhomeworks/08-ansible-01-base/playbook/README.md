# Самоконтроль выполненения задания

1. Где расположен файл с `some_fact` из второго пункта задания?
> playbook/group_vars/all/
2. Какая команда нужна для запуска вашего `playbook` на окружении `test.yml`?
> `ansible-playbook -i inventory/test.yml site.yml`
3. Какой командой можно зашифровать файл?
> `ansible-vault encrypt /путь/к/файлу`
4. Какой командой можно расшифровать файл?
> `ansible-vault decrypt /путь/к/файлу`
5. Можно ли посмотреть содержимое зашифрованного файла без команды расшифровки файла? Если можно, то как?
> Можно. `ansible-vault view /путь/к/файлу`
6. Как выглядит команда запуска `playbook`, если переменные зашифрованы?
> `ansible-playbook -i inventory/inventory_file.yml playbook_file.yml --ask-vault-pas`
7. Как называется модуль подключения к host на windows?
> Модуль `winrm` - Run tasks over Microsoft's WinRM
8. Приведите полный текст команды для поиска информации в документации ansible для модуля подключений ssh
> Можно поискать все модули ssh: `ansible-doc -l -t connection | grep ssh`  
> Информация по конкретному модулю: `ansible-doc -t connection ssh`
9. Какой параметр из модуля подключения `ssh` необходим для того, чтобы определить пользователя, под которым необходимо совершать подключение?
> Это параметр `remote_user`
