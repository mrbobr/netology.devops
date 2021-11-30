## Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. _Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout._  
> Выполняем команду `strace /bin/bash -c 'cd /tmp' 2>&1 | grep /tmp` и в результатах видим, что cd делает системный вызов `chdir("/tmp")`, предварительно собрав данные о каталоге с помощью `stat`
2. _Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:_
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    _Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки._  
> Изучив вывод `strace` для команды `file`, видим, что сначала осуществляется попытка чтения файла БД из каталогов /home/vagrant/ и /etc .
> В первом файла нет, во втором файл есть, но нет данных, поэтому далее поиск ведется в файле /usr/share/misc/magic.mgc. Это символическая ссылка на файл `/usr/lib/file/magic.mgc`
3. _Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе)._
> Ищем файловый дескриптор X и PID процесса, который пишет в удаленный файл: `lsof | grep <название процесса> | grep '<название файла> (deleted)'`  
> Для обнуления достаточно выполнить, подставив найденные PID и X: `> /proc/PID/fd/X`
4. _Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?_
> Зомби-процессы сами по себе не потребляют CPU, RAM и IO, т.к. это завершенные процессы и потребляемые ими ресурсы уже освобождены. Но еще в таблице процессов остается запись зомби-процесса, которая занимает незначительное кол-во RAM. Также зомби-процесс использует PID, которых в ОС ограниченное количество. Если зомби-процессы будут плодиться с большой скоростью, то может возникнуть ситуация, когда запуск новых процессов станет невозможным из-за отсутствия свободных PID.  

5._В iovisor BCC есть утилита `opensnoop`:_  
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```  
    _На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md)._  
> Выполнялось из под root:
```
PID    COMM               FD ERR PATH
1      systemd            12   0 /proc/389/cgroup
774    vminfo              4   0 /var/run/utmp
576    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
576    dbus-daemon        18   0 /usr/share/dbus-1/system-services
576    dbus-daemon        -1   2 /lib/dbus-1/system-services
576    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
```
6. _Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС._  
> Используется системный вызов `uname()`  
> Цитата: `Part of the utsname information is also accessible  via  /proc/sys/ker‐nel/{ostype, hostname, osrelease, version, domainname}.`
7. _Чем отличается последовательность команд через `;` и через `&&` в bash? Например:_
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
   > Через `;` все команды выполнятся вне зависимости от возвращаемых кодов выполнения  
   >Если использовать `&&`, то следующая команда (в нашем случае `echo`) выполнится только если предыдущая команда `test` выполнится успешно (вернет код 0)

    _Есть ли смысл использовать в bash `&&`, если применить `set -e`?_  
> `set -e` позволяет немедленно прекратить работу команды, если результат её выполнения отличается от успешного(0).  
> Применение данной опции бессмысленно, т.к. команда после `&&` выполнится в любом случае. Возможно, есть смысл использовать, если не нужны стандартные выводы 1 и 2 предыдущей команды, но их можно перенаправить другим способом, например, в dev/null
8. _Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?_  
> `-e` обеспечивает немедленный выход, если команда завершается со статусом отличным от 0  
> `-u` устанавливает обработку необъявленных переменных и параметров. При попытке подстановки таких переменных оболочка выведет ошибку и в случае неинтерактивного режима произведет выход с ненулевым статусом.  
> `-x` отображает значение переменной оболочки PS4 (имя команды и аргументы) после выполнения каждой простой или составной команды.  
> `-o pipefail` при использовании конвейера возвращает статус конвейера равный последнему ненулевому статусу выполнившейся команды. В случае успешного завершения всех команд в конвейере вернет 0.  
> По описаниям опций можно сделать вывод, что данный режим bash будет очень полезен при пошаговой отладке для обеспечения безошибочной работы скриптов, в т.ч. для отлова "невыполнившихся" в конвейере команд, которые в обычном режиме могли остаться незамеченными.  
9. _Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными)._  
> Описание дополнительных статусов: 
```
               <    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
               +    is in the foreground process group

```
>Вывод уникальных статусов процессов `ps -eo stat | grep -v STAT | sort | uniq`:  
```
I
I<
R+
S
S+
Sl
SLsl
SN
S<s
Ss
Ss+
Ssl
```
> Наиболее часто встречающийся статусы процессов:  
> S - процессы ожидающие завершения (прерывистый сон)  
> I - фоновые процессы ядра