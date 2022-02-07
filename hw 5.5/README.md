1. Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
* replication запускает контейнеры в режиме реплики и они обрабатывают как единое целое задачи своего контейнера. global же запускает на каждой ноде свою версию контейнера и она работает как отдельный запущенный контейнер (применяется для запуска контейнеров с мониторингом самих нод, например).
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?
* Для выбора лидер используется довольно сложный механизм RAFT
- Что такое Overlay Network?
* это виртуальная сеть по которой общаются между собой контейнеры в кластере. Их создает сам пользователь и их можно прикрепить к контейнерам. Эти сети служат общей подсетью для контейнеров единой сети, в которой они могут обмениваться данными напрямую (даже если они запущены на разных физических хостах).

2. Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:

docker node ls

```
[centos@node01 ~]$ sudo docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
fawtde2w0wukmkj4acw68axpn *   node01.netology.yc   Ready     Active         Leader           20.10.12
i2v5exzvmi4cn63244u8zd0e9     node02.netology.yc   Ready     Active         Reachable        20.10.12
un5u6em1uldluduwk7rugmpum     node03.netology.yc   Ready     Active         Reachable        20.10.12
y77xlx65ukbsst671hj2zqga1     node04.netology.yc   Ready     Active                          20.10.12
ocp41rmi81fwuc7jol4h6pyx7     node05.netology.yc   Ready     Active                          20.10.12
imymlrodncgx4jpon0h036sga     node06.netology.yc   Ready     Active                          20.10.12
```

3. Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:

docker service ls

```
[centos@node01 ~]$ sudo docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
z0ksrris3sju   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0
27dq8sgyhcj8   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
detcsoqysgr6   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest
4ej54ov0svx9   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest
38qtp9lqzttr   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4
6gcza7f8iysv   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0
mm81yqdjgmbg   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0
c6ei8fxiud6f   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0
```

4. Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:

docker swarm update --autolock=true

Как я понял из мануала. По дефолту все логи общения кластера - Raft логи хранятся в зашифрованном виде на менеджерах кластера.
При старте докера для расшифровки логов и для коммуникации между нодами используются одни и те же ключи TLS. 
Если включить autolock то swarm кластер при запуске не начнет функционировать и ноды не будут общаться между собой, до тех пор пока не будет введен ключ разблокировки.
Собственно это дополнительная защита от несакционированного доступа к кластеру. Например увезли ваш сервер товарищи из органов, запустили его у себя, но кластер не стартанет и соответственно никаких данных снять с него не получится. 
Чем то напоминает механизм в hashicopr vault, где при запуске надо распечатать склеп несколькими ключами.