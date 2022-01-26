# Домашнее задание к занятию "5.1. Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения."


## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате учебной группы.

---

## Задача 1

_Опишите кратко, как вы поняли: в чем основное отличие полной (аппаратной) виртуализации, паравиртуализации и виртуализации на основе ОС._  
> Основным отличием является способ предоставления физических ресурсов сервера виртуальным машинам: гипервизор предоставляет ресурсы без участия дополнительной ОС; гипервизор предоставляет ресурсы, получая их от хостовой ОС; сама хостовая ОС предоставляет ресурсы для ВМ.  
> ___
> Дополнение:  
> _В чём разница при работе с ядром гостевой ОС для полной и паравиртуализации?_  
> При полной виртуализации гипервизор предоставляет аппаратные ресурсы гостевой ОС не затрагивая её ядро, эмулируя физические устройства таким образом, что гостевая ОС считает их своими (реальными).  
> В случае паравиртуализации гипервизор модифицирует ядро гостевой ОС, чтобы иметь возможность предоставлять ей ресурсы программно посредством их запроса у ОС хоста.

## Задача 2

_Выберите один из вариантов использования организации физических серверов, в зависимости от условий использования._  

Организация серверов:
- физические сервера,
- паравиртуализация,
- виртуализация уровня ОС.

Условия использования:
- Высоконагруженная база данных, чувствительная к отказу.
- Различные web-приложения.
- Windows системы для использования бухгалтерским отделом.
- Системы, выполняющие высокопроизводительные расчеты на GPU.

Опишите, почему вы выбрали к каждому целевому использованию такую организацию.  
> - Высоконагруженная база данных, чувствительная к отказу. При данном варианте для минимизации отказов и задержек I/O подходит кластер из физических серверов, т.к. использование гипервизора привносит дополнительный риск отказа и использует часть ресурсов физического сервера. Для хранилищ обязательно использовать RAID и сетевые схемы подключения с резервными соединениями.  
> - Различные web-приложения - виртуализация уровня ОС. В данном случае, думаю, оптимально использовать docker. Это позволит нам использовать любые из имеющихся доступных хостовых ОС не заботясь о единообразии развертывания приложений. Также с технологией получаем высокую скорость развертывания, возможность максимальной утилизации ресурсов и упрощенного масштабирования в будущем.   
> - Windows системы для использования бухгалтерским отделом - паравиртуализация. Немного непонятно это АРМ пользователей или серверы приложений, но в обоих случаях нам требуется не особо высокопроизводительное решение и желательно бесплатно :). Т.к. у нас Windows системы, то, очевидно, выбираем Hyper-V (скорее всего у нас в инфраструктуре уже есть Windows Server). В случае серверов приложений и, если у нас имеются сервера на Linux, то opensource альтернативой может послужить KVM.
> - Системы, выполняющие высокопроизводительные расчеты на GPU. Как я понимаю, для таких систем не очень критична исключительная отказоустойчивость, т.к. мы можем заменять выходящие из строя сегменты комплекса "на лету" без заметной просадки в производительности. Зато необходимы минимальные задержки в цепочке физический ресурс-гипервизор-приложения. Минимальные задержки будут при отсутствии виртуализации вообще, т.е. система на физических серверах, объединенных по сети. При необходимости использования гипервизора подходит аппаратная виртуализация. Если мы можем позволить себе железо с GPU, то скорее всего можем оплатить гипервизор VMWare(ESXi) :) _Также вычитал, что Xen умеет пробрасывать конкретные физические GPU на гостевые ВМ, что позволяет достичь производительности, как на физическом сервере._


## Задача 3

Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.

Сценарии:

1. 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий.  
> Т.к. у нас преимущественно Windows based инфраструктура, то выбор склоняется в пользу Hyper-V (generation 2 с поддержкой до 240 CPU/VM), который поддерживает ВМ на базе Windows и Linux. При невозможности использовать Hiper-V gen2, используем vSphere. Оба гипервизора предоставляют возможности по балансировке нагрузки, репликации ВМ и бэкапировании ВМ (встроенными и сторонними средствами).  
2. Требуется наиболее производительное бесплатное open source решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.  
> Универсальное c точки зрения ОС (Windows, Linux) и производительное (за счет изолированных физических ресурсов для гипервизора) open sourse решение для небольшого кол-ва ВМ (до32) - XenServer.  
3. Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows инфраструктуры.  
> Если у нас в инфраструктуре уже имеются серверы Windows Server, то, несомненно, необходимо использовать Hyper-V, т.к. это максимально совместимый бесплатный компонент устанавливаемый включением роли на имеющемся Windows Server. Либо скачиваем и устанавливаем бесплатно Hiper-V Server, как отдельную ОС (аппаратный гипервизор). Но бесплатность, естественно, обуславливается уже оплаченными серверными и пользовательскими лицензиями ПО, которое будет работать на гипервизоре(ах).  
4. Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.  
> Для быстрого решения такой задачи проще всего использовать бесплатные гипервизоры для паравиртуализации: KVM (в случае имеющейся Linux инфраструктуры) или Virtualbox (в случае смешанной windows/linux инфраструктуры). И для KVM, и для VirtualBox есть возможность получить большое количество готовых образов различных ОС, что сильно упрощает задачу и уменьшает время развертывания ВМ.  
> В случае систематического тестирования ПО и ограниченности в физических ресурсах, лучшим решением будет использование docker. Время, первоначально затраченное на настройку образов, окупится скоростью и легкостью разворачивания сред тестирования в дальнейшем.  

## Задача 4

Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был выбор, то создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.  
> 1. Недостаточность в квалификации или отсутствие необходимого опыта у персонала по работе с некоторыми системами управления виртуализацией.
> 2. Возможная несовместимость гипервизоров при работе в одной физической среде.
> 3. Подверженность сбоям всей инфрастуктуры при недостаточности вычислительных ресурсов или при попытке совместного использования физических ресурсов при неверной настройке.
> 4. Ошибки в настройке резервного копирования.
>
> Для минимизации рисков возникновения озвученных проблем:
> - Обучение персонала на специализированных курсах
> - Тщательное документирование виртуализируемых сред
> - Настройка мониторинга с оповещениями об утилизации физических ресурсов и ВМ
> - Изоляция физических серверов разных гипервизоров друг от друга
> - Использование для репликации и бэкапирования ВМ только встроенных средств гипервизора
> 
> С нуля создавать виртуальную среду предприятия, используя более одного гипервизора с аппаратной виртуализацией, точно не стал бы. Сложно в управлении и мониторинге. Возможно появление гетерогенной среды при необходимости более позднего добавления гипервизора, который сможет удовлетворять вновь появившимся требованиям. Но оптимально, в таком случае было бы разместить дополнительные серверы в облаке (IaaS), если нет необходимости нахождения физических серверов на одной площадке.
> Пример: на первоначальном этапе развития компания использует XenServer, как максимально надежный и универсальный. С течением времени бизнес расширяется и компания начинает поставлять новые решения. При расчете и планировании выясняется, что использовать Xen не можем, так как упираемся в ограничение по количеству ВМ на одной площадке. В зависимости от требований к инфраструктуре от новых систем разворачиваем виртуальную среду на новом гипервизоре у себя на изолированной площадке, либо покупаем облачные мощности. Старую систему не мигрируем, т.к. нерентабельно/не соответствует требованиям/и так все прекрасно работает.  
> Не вижу ничего плохого в использовании паравиртуализации и/или виртуализации средствами ОС поверх аппаратного гипервизора. Более того, использование VirtualBox или контейнеров может оказаться оптимальным решением для конкретных целей и приложений. Пример: имеем настроенную внутреннюю инфраструктуру компании на базе Windows Server и Windows клиентов. (АРМ и серверы приложений для внутреннего пользования). Настроена виртуализация посредством Hyper-V. В определенный момент возникает необходимость организовать у себя на площадке высокопроизводительное, отказоустойчивое приложение с возможностью постоянного горизонтального масштабирования. С помощью Hyper-V нарезаем ВМ для комплекса, а на них посредством docker контейнеров запускаем/останавливаем серверы с разными ролями балансировщик/сервер приложений/СУБД.