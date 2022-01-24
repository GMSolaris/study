
## Задача 1

Опишите кратко, как вы поняли: в чем основное отличие полной (аппаратной) виртуализации, паравиртуализации и виртуализации на основе ОС.

```
Аппаратная виртулизация использует железо (аппаратные ресурсы) для запуска ядра ОС (псевдо ОС), которая уже размещает гостевые машины. Это есть полная виртуализация.
Паравиртуализация, это когда на железо ставится определенная ОС, которая может как выполнять функции ОС, так и функции гипервизора, так и прикладные приложения внутри ОС.
Виртуализация на основа ОС, это в основном докер контейнеры и схожие. Применяется для запуска различных приложений, выполняемых на данном типе ядра и процессора, но в ограниченных средах.
```

## Задача 2

Выберите один из вариантов использования организации физических серверов, в зависимости от условий использования.

Организация серверов:
- физические сервера,
- паравиртуализация,
- виртуализация уровня ОС.

Условия использования:
- Высоконагруженная база данных, чувствительная к отказу. 
``` Тут бы я использовал физический сервер, так как он априори быстрее чем виртуальная машина, запущенная на нем же. Плюс сама по себе база не требует огромного кол-ва софта, для запуска. При падении сервера, достаточно развернуть похожий севрер на другой машине и поднять там бекап. К тому же часто сервера баз данных занимают очень большой объем, так что зеркалирование или резервное копирование целого сервера - весьма затратное развлечение. Для подстраховки сервера баз данных неплохо иметь на другом физическом сервере репилку основного. Они используется для чтения (запросы аналитиков, резервное копирование, другие запросы на чтение). В случае выхода из строя мастера, реплика служит сервером подменяющим, пока мастер восстанавливается.
```
- Различные web-приложения.
```
 Тут оптимально подойдут контейнеры докера, если все выполняется в рамках одной среды, например линкус. Все приложения в свои контейнеры.
```

- Windows системы для использования бухгалтерским отделом.
```
 вин софт полноценно работает из коробки с hyper-v. Тем более бухия и значит там 1С. Проброс ключей usb внутрь машин, администрирование и тд. Все это есть в стоке в гипер-в, тем более там где уже используется среда вин, есть и гипер-в.
```

- Системы, выполняющие высокопроизводительные расчеты на GPU.
```
Сервера для использования GPU используются не часто. GPU в целом нужны для мат расчетов и майнинга. Кол-во процессоров не особо важно. Можно просто ставить софт на небольшой ссд диск и подключать как можно больше GPU  к материнской плате. Ввиду этого виртуализация не особо нужна. Но неплохо расчеты GPU переносить в облако. 
```
Опишите, почему вы выбрали к каждому целевому использованию такую организацию.

## Задача 3

Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.

Сценарии:

1. 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий.
* Hyper-V Там где развита система Вин, там уже есть 100% сервера на ней основанные. Почти всегда из мелких и средних компаний вырастают такие конфигурации. Развернуть на гипер-в 100 машин смешанного типа и с заданными требованиями не составляет проблем.

2. Требуется наиболее производительное бесплатное open source решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.
* Тут определенно подойдет KVB и proxmox. Дешево и сердито.

3. Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows инфраструктуры.
* Если нужно хостить вин то лучше гипер-в нет ничего. Но поскольку требуется бесплатное! (что уже странно, исходя из того, что сама гостевая винда будет совсем не бесплатна), то можно поднять KVM и Proxmox. Но лучше поднять вин север и гипер-в.

4. Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.
*Тут я бы посоветовал что-то вроде одной машины с KVM которая поднимает несколько линуксов и там дальше крутим контейнеры. 

## Задача 4

Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был выбор, то создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.

 Гетерогенная среда дает как преимущества, так и недостатки. Преимущества:
```
 - разнообразная среда (можно запускать все что угодно)
 - разые ОС и типы процессоров
 - нет привязки к архитектуре
 - поддерживаем тот зоопарк железа, который нужен
```
Недостаки:
```
- везде все разное, ПО, железо, политики, бекапы
- нет возможности использовать одно железо для разных целей
- сложность поддержки (нужно большое специалистов)
```

Если бы была возможность - не создавал бы такую среду. 
Но имитация её частей - полезна. Или часть софта переводил бы в одну среду, часть в другую и создавал структуры, которые раздельно поддерживают каждый свою.


