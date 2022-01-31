1. Сценарий выполения задачи:

создайте свой репозиторий на https://hub.docker.com;
- выполнено 
выберете любой образ, который содержит веб-сервер Nginx;
- берем самый первый офф образ nginx:stable на основе дебиана
создайте свой fork образа;
Делаем на основе этого образа свой, через Dockerfile. Заодно обновляем кеш пакетного менеджера и доставляем утилиту wget. Берем из интернета нужный файл, подменяем в nginx
```
FROM nginx:stable

MAINTAINER Alexander Myagkikh <kvazik.vl@gmail.com>

ENV TZ=Asia/Vladivostok

RUN apt update
RUN apt install wget
RUN wget https://mxgroup.ru/upload/index.html
RUN rm /usr/share/nginx/html/index.html
RUN cp index.html /usr/share/nginx/html/
```
Собираем образ 
```
myagkikh@netology:~/mynginx$ sudo docker build -t gmsolaris/nginx:v1 .
[sudo] пароль для myagkikh:
Sending build context to Docker daemon  2.048kB
Step 1/8 : FROM nginx:stable
 ---> d6c9558ba445
Step 2/8 : MAINTAINER Alexander Myagkikh <kvazik.vl@gmail.com>
 ---> Running in b794a7eaf87e
Removing intermediate container b794a7eaf87e
 ---> 0070df5cd16c
Step 3/8 : ENV TZ=Asia/Vladivostok
 ---> Running in ed4ebe6df1dd
Removing intermediate container ed4ebe6df1dd
 ---> 3c85615cad74
Step 4/8 : RUN apt update
 ---> Running in 8da4b7c78689
 ..........
```
реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
Запускаем наш образ  sudo docker run -itd --name nginx_netology -p 80:80 gmsolaris/nginx:v1
Проверяем

![alt text](nginx.png "nginx")

Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки
docker pull gmsolaris/nginx
https://hub.docker.com/r/gmsolaris/nginx

2. Посмотрите на сценарий ниже и ответьте на вопрос: "Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.
Сценарий:

Высоконагруженное монолитное java веб-приложение; Не подходит. Для высоконагруженных монолитов лучше подойдет виртуальная машина.
Nodejs веб-приложение;
Мобильное приложение c версиями для Android и iOS;
Шина данных на базе Apache Kafka;
Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
Мониторинг-стек на базе Prometheus и Grafana;
MongoDB, как основное хранилище данных для java-приложения;
Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

