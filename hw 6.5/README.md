1. Используя докер образ centos:7 как базовый и документацию по установке и запуску Elastcisearch:

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте push в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути / c хост-машины

```
FROM centos:7

MAINTAINER Alexander Myagkikh <kvazik.vl@gmail.com>

ENV TZ=Asia/Vladivostok

ENV PATH=/usr/lib:/usr/lib/jvm/jre-11/bin:$PATH

RUN yum install perl-Digest-SHA -y

RUN yum install java-11-openjdk -y

RUN yum install wget -y

RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch


RUN echo "[elasticsearch]" >>/etc/yum.repos.d/elasticsearch.repo &&\
    echo "name=Elasticsearch repository for 7.x packages" >>/etc/yum.repos.d/elasticsearch.repo &&\
    echo "baseurl=https://artifacts.elastic.co/packages/7.x/yum">>/etc/yum.repos.d/elasticsearch.repo &&\
    echo "gpgcheck=1">>/etc/yum.repos.d/elasticsearch.repo &&\
    echo "gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch">>/etc/yum.repos.d/elasticsearch.repo &&\
    echo "enabled=0">>/etc/yum.repos.d/elasticsearch.repo &&\
    echo "autorefresh=1">>/etc/yum.repos.d/elasticsearch.repo &&\
    echo "type=rpm-md">>/etc/yum.repos.d/elasticsearch.repo

RUN yum install -y --enablerepo=elasticsearch elasticsearch

ADD elasticsearch.yml /etc/elasticsearch/

RUN mkdir /usr/share/elasticsearch/snapshots &&\
    chown elasticsearch:elasticsearch /usr/share/elasticsearch/snapshots

RUN mkdir /var/lib/logs \
    && chown elasticsearch:elasticsearch /var/lib/logs \
    && mkdir /var/lib/data \
    && chown elasticsearch:elasticsearch /var/lib/data


USER elasticsearch
CMD ["/usr/sbin/init"]
CMD ["/usr/share/elasticsearch/bin/elasticsearch"]
```

Образ на dockerhub - gmsolaris/elk:v3
Ответ на запрос curl localhost:9200
```
myagkikh@netology:~/hw6.5$ curl localhost:9200/
{
  "name" : "c00bde2297ba",
  "cluster_name" : "netology_test",
  "cluster_uuid" : "ijFIe1WiSFK-OuHm0PPnow",
  "version" : {
    "number" : "7.17.1",
    "build_flavor" : "default",
    "build_type" : "rpm",
    "build_hash" : "e5acb99f822233d62d6444ce45a4543dc1c8059a",
    "build_date" : "2022-02-23T22:20:54.153567231Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

2. Ознакомтесь с документацией и добавьте в elasticsearch 3 индекса, в соответствии со таблицей:




Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

Имя	Количество реплик	Количество шард
ind-1	0	1
ind-2	1	2
ind-3	2	4
```
curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 2,  "number_of_replicas": 1 }}'
curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 4,  "number_of_replicas": 2 }}' 
```

Получите список индексов и их статусов, используя API и приведите в ответе на задание.
```
myagkikh@netology:~/hw6.5$ curl -X GET 'localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases G_w6DrTbRo2wDTyn4kJZmg   1   0         44            0     41.8mb         41.8mb
green  open   ind-1            p-k41htnSQ-1PgDQKsbLiw   1   0          0            0       226b           226b
```

Получите состояние кластера elasticsearch, используя API.
```
myagkikh@netology:~/hw6.5$  curl -X GET 'localhost:9200/_cluster/health/ind-1?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
  
myagkikh@netology:~/hw6.5$ curl -X GET 'localhost:9200/_cluster/health/ind-2?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}

myagkikh@netology:~/hw6.5$ curl -X GET 'localhost:9200/_cluster/health/ind-3?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 4,
  "active_shards" : 4,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 8,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
```
Статус кластера
```
myagkikh@netology:~/hw6.5$ curl -X GET 'localhost:9200/_cluster/health/?pretty=true'
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 10,
  "active_shards" : 10,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
```

Удаление индексов
```
myagkikh@netology:~/hw6.5$ curl -X DELETE 'localhost:9200/ind-1?pretty'
{
  "acknowledged" : true
}
myagkikh@netology:~/hw6.5$ curl -X DELETE 'localhost:9200/ind-2?pretty'
{
  "acknowledged" : true
}
myagkikh@netology:~/hw6.5$ curl -X DELETE 'localhost:9200/ind-3?pretty'
{
  "acknowledged" : true
}
```

В двух индексах у нас были указаны несколько реплик, но их нет физически,
так как сервер запущен в единственном экземпляре, по этому они работоспособны но статус Yellow.
Соответственно и статус всего кластера тоже Yellow.

3. В данном задании вы научитесь:

- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Используя API зарегистрируйте данную директорию как snapshot repository c именем netology_backup.
```
myagkikh@netology:~/hw6.5$ curl -X POST localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/usr/share/elasticsearch/snapshots" }}'
{
  "acknowledged" : true
}
```


```
myagkikh@netology:~/hw6.5$ curl -X GET localhost:9200/_snapshot/netology_backup?pretty
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "/usr/share/elasticsearch/snapshots"
    }
  }
}
```

Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.
```
myagkikh@netology:~/hw6.5$ curl -X PUT localhost:9200/test -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'

myagkikh@netology:~/hw6.5$ curl -X GET localhost:9200/test?pretty
{
  "test" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "test",
        "creation_date" : "1647928603313",
        "number_of_replicas" : "0",
        "uuid" : "bhGaWdoFRlK3Dc27tTWxlQ",
        "version" : {
          "created" : "7170199"
        }
      }
    }
  }
}
```

Создайте snapshot состояния кластера elasticsearch.
```
myagkikh@netology:~/hw6.5$ curl -X PUT localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true
{"snapshot":{"snapshot":"elasticsearch","uuid":"75OBnYsxRhG0ugC2rHYlqg","repository":"netology_backup","version_id":7170199,"version":"7.17.1","indices":[".ds-.logs-deprecation.elasticsearch-default-2022.03.22-000001",".geoip_databases",".ds-ilm-history-5-2022.03.22-000001","test"],"data_streams":["ilm-history-5",".logs-deprecation.elasticsearch-default"],"include_global_state":true,"state":"SUCCESS","start_time":"2022-03-22T05:59:48.646Z","start_time_in_millis":1647928788646,"end_time":"2022-03-22T05:59:50.247Z","end_time_in_millis":1647928790247,"duration_in_millis":1601,"failures":[],"shards":{"total":4,"failed":0,"successful":4},"feature_states":[{"feature_name":"geoip","indices":[".geoip_databases"]}]}}

bash-4.2$ cd /usr/share/elasticsearch/snapshots/
bash-4.2$ ls -lh
total 48K
-rw-r--r-- 1 elasticsearch elasticsearch 1.4K Mar 22 15:59 index-0
-rw-r--r-- 1 elasticsearch elasticsearch    8 Mar 22 15:59 index.latest
drwxr-xr-x 6 elasticsearch elasticsearch 4.0K Mar 22 15:59 indices
-rw-r--r-- 1 elasticsearch elasticsearch  29K Mar 22 15:59 meta-75OBnYsxRhG0ugC2rHYlqg.dat
-rw-r--r-- 1 elasticsearch elasticsearch  712 Mar 22 15:59 snap-75OBnYsxRhG0ugC2rHYlqg.dat
```


Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов
```
myagkikh@netology:/$ curl -X DELETE 'localhost:9200/test?pretty'
{
  "acknowledged" : true
}

myagkikh@netology:/$ curl -X PUT localhost:9200/test-2?pretty -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}

myagkikh@netology:/$ curl -X POST localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?pretty -H 'Content-Type: application/json' -d'{"include_global_state":true}'
{
{
  "accepted" : true
}
myagkikh@netology:/$ curl -X GET localhost:9200/_cat/indices?v
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 p61ZpfTfRNqpkz915IbBdw   1   0          0            0       208b           208b
green  open   test   bhGaWdoFRlK3Dc27tTWxlQ   1   0          0            0       208b           208b

```



