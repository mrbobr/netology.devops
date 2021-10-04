#Домашнее задание к занятию «2.4. Инструменты Git»
___
1. _Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea:_
>`$ git show -s --pretty=oneline aefea`  
**aefead2207ef7e2aa5dc81a34aedf0cad4c32545 Update CHANGELOG.md**
___
2. _Какому тегу соответствует коммит 85024d3?_  
>`$ git show -s --oneline  85024d3`  
85024d310 (tag: **v0.12.23**) v0.12.23
___
3. _Сколько родителей у коммита b8d720? Напишите их хеши:_  
Два родителя:  
>`$ git show -s --pretty=%p b8d720`  
**56cd7859e 9ea88f22f**  
___
4. _Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24:_  
>`$ git show -s --oneline v0.12.23..v0.12.24^`  
**b14b74c49 [Website] vmc provider links  
3f235065b Update CHANGELOG.md  
6ae64e247 registry: Fix panic when server is unreachable  
5c619ca1b website: Remove links to the getting started guide's old location  
06275647e Update CHANGELOG.md  
d5f9411f5 command: Fix bug when using terraform login on Windows  
4b6d06cc5 Update CHANGELOG.md  
dd01a3507 Update CHANGELOG.md  
225466bc3 Cleanup after v0.12.23 release**  
___
5. _Найдите коммит, в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...):_  
+ Поиск файлов, в которых встречается функция:  
>`$ git grep --name-only -p 'func providerSource('`  
**provider_source.go**  


+ Нашли файл _provider_source.go_ и теперь ищем историю изменений функции в файле:  

>`$ git log -s --oneline -L :providerSource:provider_source.go`  
5af1e6234 main: Honor explicit provider_installation CLI config when present  
92d6a30bb main: skip direct provider installation for providers available locally  
8c928e835 main: Consult local directories as potential mirrors of providers  
+ Коммит **8c928e835** - первый в истории изменений. Можно проверить, что функция создана именно в нем:  
> `$ git show 8c928e835`  
diff --git a/provider_source.go b/provider_source.go  
**new file** mode 100644  
index 000000000..9524e0985  
--- /dev/null  
    +++ b/provider_source.go  
> ...  
+func **providerSource**(services *disco.Disco) getproviders.Source {

___
6. _Найдите все коммиты в которых была изменена функция globalPluginDirs:_  
>`$ git log -s --oneline -L :globalPluginDirs:plugins.go`  
78b122055 Remove config.go and update things using its aliases  
52dbf9483 keep .terraform.d/plugins for discovery  
41ab0aef7 Add missing OS_ARCH dir to global plugin paths  
66ebff90c move some more plugin search path logic to command  
8364383c3 Push plugin discovery down into command package  
  
Функция была изменена в коммитах: 78b122055 52dbf9483 41ab0aef7 66ebff90c
___
7. _Кто автор функции synchronizedWriters?_  
>`$ git grep --heading -p 'func synchronizedWriters('`  
> 
Команда поиска функции по репозиторию не выдала ни одного результата. Файл видимо был удален, поэтому попробуем найти все коммиты, в которых добавлялась или удалялась строка:  
>`$ git log --oneline  -S 'func synchronizedWriters('`  
bdfea50cc remove unused  
5ac311e2a main: synchronize writes to VT100-faker on Windows  

Смотрим содержимое коммита 5ac311e2a и находим автора:  
`git show 5ac311e2a`  
**Author: Martin Atkins <mart@degeneration.co.uk>**