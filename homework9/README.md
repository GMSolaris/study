1. Для выполнения задания решил на пустой машине под deb11 поднять прометея и node_exporter в дальнейшем пригодится в работе.
Описывать установку прометея не буду. А вот установку node_exporter в качестве демона распишу подробно.
```
root@zabbix:~# curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest| grep browser_download_url|grep linux-amd64|cut -d '"' -f 4|wget -qi -
root@zabbix:~# tar -xvf node_exporter*.tar.gz
node_exporter-1.3.0.linux-amd64/
node_exporter-1.3.0.linux-amd64/LICENSE
node_exporter-1.3.0.linux-amd64/NOTICE
node_exporter-1.3.0.linux-amd64/node_exporter
root@zabbix:~# cd  node_exporter*/
root@zabbix:~/node_exporter-1.3.0.linux-amd64# cp node_exporter /usr/local/bin
root@zabbix:~/node_exporter-1.3.0.linux-amd64# node_exporter --version
node_exporter, version 1.3.0 (branch: HEAD, revision: c65f870ef90a4088210af0319498b832360c3366)
  build user:       root@4801f8f250a6
  build date:       20211118-16:34:14
  go version:       go1.17.3
  platform:         linux/amd64
```
Теперь завернем node_exporter в демона и добавим в него аргумент на запуск $EXTRA_OPTS
```
root@zabbix:~/node_exporter-1.3.0.linux-amd64# sudo tee /etc/systemd/system/node_exporter.service <<EOF
> [Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
ExecStart=/usr/local/bin/node_exporter $EXTRA_OPTS

[Install]
WantedBy=default.target
```
Проверяем что все запущено верно
```
root@zabbix:~/node_exporter-1.3.0.linux-amd64# systemctl daemon-reload
root@zabbix:~/node_exporter-1.3.0.linux-amd64# systemctl start node_exporter
root@zabbix:~/node_exporter-1.3.0.linux-amd64# systemctl enable node_exporter
Created symlink /etc/systemd/system/default.target.wants/node_exporter.service → /etc/systemd/system/node_exporter.service.
root@zabbix:~/node_exporter-1.3.0.linux-amd64# systemctl status node_exporter.service
● node_exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2021-11-24 11:50:10 +10; 10s ago
   Main PID: 500290 (node_exporter)
      Tasks: 5 (limit: 23395)
     Memory: 3.6M
        CPU: 10ms
     CGroup: /system.slice/node_exporter.service
             └─500290 /usr/local/bin/node_exporter

ноя 24 11:50:10 zabbix node_exporter[500290]: ts=2021-11-24T01:50:10.798Z caller=node_exporter.go:115 level=info collector=thermal_zone
ноя 24 11:50:10 zabbix node_exporter[500290]: ts=2021-11-24T01:50:10.798Z caller=node_exporter.go:115 level=info collector=time
ноя 24 11:50:10 zabbix node_exporter[500290]: ts=2021-11-24T01:50:10.798Z caller=node_exporter.go:115 level=info collector=timex
ноя 24 11:50:10 zabbix node_exporter[500290]: ts=2021-11-24T01:50:10.798Z caller=node_exporter.go:115 level=info collector=udp_queues
ноя 24 11:50:10 zabbix node_exporter[500290]: ts=2021-11-24T01:50:10.798Z caller=node_exporter.go:115 level=info collector=uname
ноя 24 11:50:10 zabbix node_exporter[500290]: ts=2021-11-24T01:50:10.798Z caller=node_exporter.go:115 level=info collector=vmstat
ноя 24 11:50:10 zabbix node_exporter[500290]: ts=2021-11-24T01:50:10.798Z caller=node_exporter.go:115 level=info collector=xfs
ноя 24 11:50:10 zabbix node_exporter[500290]: ts=2021-11-24T01:50:10.798Z caller=node_exporter.go:115 level=info collector=zfs
ноя 24 11:50:10 zabbix node_exporter[500290]: ts=2021-11-24T01:50:10.798Z caller=node_exporter.go:199 level=info msg="Listening on" address=:9100
ноя 24 11:50:10 zabbix node_exporter[500290]: ts=2021-11-24T01:50:10.798Z caller=tls_config.go:195 level=info msg="TLS is disabled." http2=false
```

2. Для мониторинга хоста выбрал бы это:
# TYPE process_cpu_seconds_total counter
process_cpu_seconds_total 0.45

# TYPE node_cpu_seconds_total counter
node_cpu_seconds_total{cpu="0",mode="idle"} 181954.31
node_cpu_seconds_total{cpu="0",mode="iowait"} 210.44
node_cpu_seconds_total{cpu="0",mode="irq"} 0
node_cpu_seconds_total{cpu="0",mode="nice"} 314.92
node_cpu_seconds_total{cpu="0",mode="softirq"} 350.22
node_cpu_seconds_total{cpu="0",mode="steal"} 0
node_cpu_seconds_total{cpu="0",mode="system"} 1449.69
node_cpu_seconds_total{cpu="0",mode="user"} 6124.88

# TYPE process_virtual_memory_max_bytes gauge
process_virtual_memory_max_bytes 1.8446744073709552e+19

# TYPE node_memory_MemFree_bytes gauge
node_memory_MemFree_bytes 7.294304256e+09

# TYPE node_network_receive_bytes_total counter
node_network_receive_bytes_total{device="eth0"} 3.5862233704e+10
node_network_receive_bytes_total{device="lo"} 7.9681915287e+10

# TYPE node_network_transmit_bytes_total counter
node_network_transmit_bytes_total{device="eth0"} 2.1017343931e+10
node_network_transmit_bytes_total{device="lo"} 7.9681915287e+10

# TYPE node_network_up gauge
node_network_up{device="eth0"} 1
node_network_up{device="lo"} 0

# TYPE node_disk_io_time_seconds_total counter
node_disk_io_time_seconds_total{device="sda"} 6694.744
node_disk_io_time_seconds_total{device="sdb"} 380.788
node_disk_io_time_seconds_total{device="sr0"} 0.02


# TYPE node_disk_read_time_seconds_total counter
node_disk_read_time_seconds_total{device="sda"} 102.593
node_disk_read_time_seconds_total{device="sdb"} 6.84
node_disk_read_time_seconds_total{device="sr0"} 0.01

# TYPE node_disk_write_time_seconds_total counter
node_disk_write_time_seconds_total{device="sda"} 9283.582
node_disk_write_time_seconds_total{device="sdb"} 486.571
node_disk_write_time_seconds_total{device="sr0"} 0

3. Netdata установлена не из пакетов, а скриптом, крутится на одной машине. В целом концепция неплохая, графики дашборды полезные.
 Смущает что в последней версии добавилось облако, где надо авторизоваться в своем аккаунте. 
 По итогу на машине под рутом запускается сторонняя поделка, которая куда-то ходит в облака и что-то передает. 
 Нормальные безопасники такое запрещают на корню. 
 
 ![image](https://mxgroup.ru/upload/net_data.jpg)
 
 4. Да можно это понять. грепнуть
  ```
  dmesg | grep Hypervisor                                                                                                     
  [    0.000000] Hypervisor detected: Microsoft Hyper-V         
  ```
  
 5. fs.nr_open - лимит открытых файлов\дескрипторов. 1048576 по умолчанию. Системная настройка.
 Есть еще лимит самого шела, по умолчанию стоит 1024. Он не даст достичь в рамках одного шела системного предела. Остается открыть 1024 шела и запустить в них 1024 открытых файла :))))
 
 6. 
 
 ```
 root@myagkikh:~# ps -e | grep sleep                                                                                       
 479 pts/0    00:00:00 sleep                                                                                           
 root@myagkikh:~# nsenter --target 479 --pid --mount                                                                     
 root@myagkikh:/# ps                                                                                                       
 PID TTY          TIME CMD                                                                                               
 475 pts/0    00:00:00 sudo                                                                                              
 476 pts/0    00:00:00 bash
 486 pts/0    00:00:00 nsenter
 490 pts/0    00:00:00 ps      
 ```
 
 7. Эта команда пораждает дерево процессов которые порождают сами себя. Таким макаром сжирается память и CPU. Системе становится плохо.
 Через некоторое время pid controller начниает этому мешать. 
 cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-4.scope
 Через ulimit -u можно задать ограничение, например, на 30 процессов, тогда подобные фокусы будут не осуществимы.
 
 
 
  