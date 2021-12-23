## Домашнее задание к занятию "3.9. Элементы безопасности информационных систем"

1. _Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей._  
![](bitwarden.png)
2. _Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.
![](GA.png)
3. _Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS._  
> Сервер apache устанавливал на VM. Добавил в конфиг Vagrantfile строку с IP своего сайта:  
> `config.vm.network "private_network", ip: "192.168.22.22"`  
> Далее устанавливаем сервер, подключаем модуль SSL, генерируем приватный ключ и сертификат:  
> ```
> sudo apt install apache2
> sudo systemctl enable apache2
> sudo a2enmod ssl
> sudo systemctl restart apache2
> sudo openssl req -x509 -nodes -days 31 -newkey rsa:2048 -keyout /etc/ssl/private/apache-ss.key -out /etc/ssl/certs/apache-ss.crt
> ```
> Настраиваем конфиг сайта:
> ```
> cd /etc/apache2/sites-available/  
> sudo mv 000-default.conf bobrosite.conf && sudo nano bobrosite.conf  
> ```

```
<VirtualHost *:443>

        ServerName bobrosite.ru
        ServerAlias www.bobrosite.ru
        DocumentRoot /var/www/bobrosite.ru

        SSLEngine on
        SSLCertificateFile /etc/ssl/certs/apache-ss.crt
        SSLCertificateKeyFile /etc/ssl/private/apache-ss.key

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
        
</VirtualHost>
> ```
> ```
>  sudo mkdir /var/www/bobrosite.ru
>  sudo nano /var/www/bobrosite.ru/index.html
>  sudo a2ensite bobrosite.conf
>  sudo apache2ctl configtest
> ```
> Записываем в /etc/hosts строку `192.168.22.22   bobrosite.ru` и перезапускаем VM.  
> Заходим по ссылке https://bobrosite.ru:

![](bobrosite.png)
4. _Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное)._    
![](testssl.png)
5. _Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу._
> На ВМ SSH уже настроен. Поэтому попробуем в обратную сторону. Устанавливаем ssh сервер на хостовой машине:    
> ```
> sudo apt install openssh-server
> sudo systemctl enable sshd.service && systemctl status sshd.service 
> ```
> В п.3 ДЗ указывали в конфиге vagrant IP виртуальной машины в результате чего появилась сеть 192.168.22.0/24, к которой принадлежат и хост и ВМ.  
> Чтобы попасть по SSH с ВМ на хост узнаем на хосте адрес интерфейса в этой сети, например, командой `ip -4 address`. Это `192.168.22.1`.  
> Сгенерируем ssh ключи c помощью утилиты `ssh-keygen` на ВМ 
> ```
> Generating public/private rsa key pair.
> Enter file in which to save the key (/home/bobro/.ssh/id_rsa): 
> Enter passphrase (empty for no passphrase): 
> Enter same passphrase again: 
> Your identification has been saved in /home/bobro/.ssh/id_rsa
> Your public key has been saved in /home/bobro/.ssh/id_rsa.pub
> The key fingerprint is:
> SHA256:Y3gkAf8yMdQRSxP3AfaUGOdzVDwQg1nQ4YPTuFqeBq8 bobro@bobro-desktop
> ```

7. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.

8. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.

 ---
### Задание для самостоятельной отработки (необязательно к выполнению)

8*. Просканируйте хост scanme.nmap.org. Какие сервисы запущены?

9*. Установите и настройте фаервол ufw на web-сервер из задания 3. Откройте доступ снаружи только к портам 22,80,443
