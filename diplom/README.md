Дипломный практикум в YandexCloud

1. Зарегистрирован домен на nic.ru.

![alt text](img/1/nic.png "nic")

В YandexCloud арендован статический адрес для проекта, в теории можно конечно заморочится и при запуске основного сервера, брать динамический адрес и прописывать его в зону автоматически, но время добавления в маршрутизацию зоны и кеш DNS серверов мешает оперативно тестировать изменения при таком раскладе.
Подобный проект реализован мною и выложен в доступ для создания сервера балансировки отказоустойчивого DNS с проверкой доступности хостов.
https://github.com/GMSolaris/yc-dns




Создана зона в yc DNS. В нее прописаны все нужные нам для работы хосты, все они ведут на основной сервер, который будет выступать у нас как и прокси для доступа к внутренним ресурсам, так и прокси для доступа с машин внутри сети в интернет.

![alt text](img/1/yc_dns.png "yc")

2. Заводим S3 бакет и в нем два workspace для наших экспериментов. 

![alt text](img/2/s3.png "s3")

В дальнейшем все данные terraform будут сохранятся в папку prod.

![alt text](img/2/s3_prod.png "s3_prod")

Подготавливаем terraform, устанавливаем провайдера yandex-cloud, проводим init.
```
myagkikh@netology:~/devops_dip/tf$ terraform init

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of yandex-cloud/yandex from the dependency lock file
- Using previously-installed yandex-cloud/yandex v0.76.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

Далее запускаем создание инфраструктуры. Поднимаются все виртуальные машины, поднимается две подсети (subnet_100 дальше в проекте не используется, просто для демонстрации возможности автоматического развертывания сетей в разных зонах). 
```
yandex_vpc_network.network-1: Creating...
yandex_vpc_network.network-1: Creation complete after 3s [id=enp2qm0d3nn7tak06jq7]
yandex_vpc_subnet.subnet-1: Creating...
yandex_vpc_subnet.subnet_100: Creating...
yandex_vpc_subnet.subnet-1: Creation complete after 1s [id=e9brh8suftpukkhhbr8a]
yandex_compute_instance.master: Creating...
yandex_compute_instance.app: Creating...
yandex_compute_instance.monitoring: Creating...
yandex_compute_instance.runner: Creating...
yandex_compute_instance.slave: Creating...
yandex_compute_instance.main_server: Creating...
yandex_compute_instance.gitlab: Creating...
yandex_vpc_subnet.subnet_100: Creation complete after 2s [id=b0c2ic02jmh8mpndlsv4]
yandex_compute_instance.app: Still creating... [10s elapsed]
yandex_compute_instance.master: Still creating... [10s elapsed]
yandex_compute_instance.monitoring: Still creating... [10s elapsed]
yandex_compute_instance.runner: Still creating... [10s elapsed]
yandex_compute_instance.slave: Still creating... [10s elapsed]
yandex_compute_instance.main_server: Still creating... [10s elapsed]
yandex_compute_instance.gitlab: Still creating... [10s elapsed]
yandex_compute_instance.app: Still creating... [20s elapsed]
yandex_compute_instance.master: Still creating... [20s elapsed]
yandex_compute_instance.monitoring: Still creating... [20s elapsed]
yandex_compute_instance.slave: Still creating... [20s elapsed]
yandex_compute_instance.runner: Still creating... [20s elapsed]
yandex_compute_instance.main_server: Still creating... [20s elapsed]
yandex_compute_instance.gitlab: Still creating... [20s elapsed]
yandex_compute_instance.slave: Creation complete after 23s [id=fhm28r2bog2fbndkps8g]
yandex_compute_instance.gitlab: Creation complete after 24s [id=fhm7puuf548gfm8sqeo6]
yandex_compute_instance.app: Creation complete after 24s [id=fhmidv06phvfeu2a9df9]
yandex_compute_instance.runner: Creation complete after 24s [id=fhm9i8keksb3nukh1sp0]
yandex_compute_instance.main_server: Creation complete after 24s [id=fhm5rsd0s1fcrce45gb1]
yandex_compute_instance.monitoring: Creation complete after 25s [id=fhmgvfk54kn52vipo6vs]
yandex_compute_instance.master: Creation complete after 25s [id=fhmkmcd4gf44vq55iqui]

Apply complete! Resources: 10 added, 0 changed, 0 destroyed.
```
В консоли YandexCloud видно появившиеся виртуальны машины.

![alt text](img/2/vms.png "vms")

Разбираем все обратно, для этапа тестирования terraform важно не забывать удалять ресурсы, чтобы не сжигать баланс.
```
yandex_compute_instance.runner: Destroying... [id=fhm9i8keksb3nukh1sp0]
yandex_compute_instance.main_server: Destroying... [id=fhm5rsd0s1fcrce45gb1]
yandex_compute_instance.monitoring: Destroying... [id=fhmgvfk54kn52vipo6vs]
yandex_vpc_subnet.subnet_100: Destroying... [id=b0c2ic02jmh8mpndlsv4]
yandex_compute_instance.master: Destroying... [id=fhmkmcd4gf44vq55iqui]
yandex_compute_instance.app: Destroying... [id=fhmidv06phvfeu2a9df9]
yandex_compute_instance.gitlab: Destroying... [id=fhm7puuf548gfm8sqeo6]
yandex_compute_instance.slave: Destroying... [id=fhm28r2bog2fbndkps8g]
yandex_compute_instance.runner: Still destroying... [id=fhm9i8keksb3nukh1sp0, 10s elapsed]
yandex_compute_instance.main_server: Still destroying... [id=fhm5rsd0s1fcrce45gb1, 10s elapsed]
yandex_vpc_subnet.subnet_100: Still destroying... [id=b0c2ic02jmh8mpndlsv4, 10s elapsed]
yandex_compute_instance.monitoring: Still destroying... [id=fhmgvfk54kn52vipo6vs, 10s elapsed]
yandex_compute_instance.master: Still destroying... [id=fhmkmcd4gf44vq55iqui, 10s elapsed]
yandex_compute_instance.gitlab: Still destroying... [id=fhm7puuf548gfm8sqeo6, 10s elapsed]
yandex_compute_instance.slave: Still destroying... [id=fhm28r2bog2fbndkps8g, 10s elapsed]
yandex_compute_instance.app: Still destroying... [id=fhmidv06phvfeu2a9df9, 10s elapsed]
yandex_vpc_subnet.subnet_100: Destruction complete after 11s
yandex_compute_instance.app: Destruction complete after 18s
yandex_compute_instance.slave: Destruction complete after 18s
yandex_compute_instance.monitoring: Destruction complete after 19s
yandex_compute_instance.master: Destruction complete after 19s
yandex_compute_instance.gitlab: Destruction complete after 19s
yandex_compute_instance.runner: Destruction complete after 19s
yandex_compute_instance.main_server: Still destroying... [id=fhm5rsd0s1fcrce45gb1, 20s elapsed]
yandex_compute_instance.main_server: Destruction complete after 22s
yandex_vpc_subnet.subnet-1: Destroying... [id=e9brh8suftpukkhhbr8a]
yandex_vpc_subnet.subnet-1: Destruction complete after 8s
yandex_vpc_network.network-1: Destroying... [id=enp2qm0d3nn7tak06jq7]
yandex_vpc_network.network-1: Destruction complete after 1s

Destroy complete! Resources: 10 destroyed.
```

Описание файлов используемых для разворачивания инфраструктуры:
- providers.tf Описание провайдеров используемых в работе, yandex, s3, авторизационные ключи доступа
- network.tf Описание сетей используемых в проекте
- variables.tf Переменные используемые в проекте
- main.tf Описание виртуальной машины используемой для основной развертки всего проекта
- mysql.tf Описание виртуальных машин используемых для создание кластера mysql (master->slave)
- app.tf Описание виртуальной машины для сервера приложений (в текущем проекте это будет Wordpress)
- gitlab.tf Описание виртуальной машины для сервера gitlab
- runner.tf Описание виртуальной машины для сервера gitlab-runner 
- monitoring.tf Описание виртуальной машины для сервера мониторинга (Prometheus, Grafana, Alretmanager)
- meta.txt Данные для доступа на виртуальные машины, которые пробрасываются при создании на каждую.

3. Для выполнения этого этапа необходимо запустить плейбук anisble/main.yml, который содержит две роли. Первая устанавливает nginx, проводит его настройку, далее устаналивает LetsEncrypt и активирует сертификаты. Так же специально в этом проекте решил попробовать использовать nginx как ssh прокси для доступа к машинам внутри сети. Можно было бы использовать ssh tunnel или jump server. Но было интересно именно организовать доступ к ресурсам внутри сети по протоколу tcp используя nginx в сочетании с модулем stream. Для этого в конфиг nginx добавлено:
load_module /usr/lib/nginx/modules/ngx_stream_module.so;
Конфиг проброса порта выглядит так
```
stream {
    server {
        listen 2201;
        proxy_connect_timeout 600s;
        proxy_timeout 600s;
        proxy_pass sql01.weltonauto.com:22;
    }
```
После установки nginx запустится вторая роль, она устанавливает простенький proxy и разрешает использовать его изнутри локальной сети, для доступа машин в интернет. 

```
myagkikh@netology:~/devops_dip/tf$ ansible-playbook ../ansible/main.yml -i ../ansible/hosts

PLAY [main] *******************************************************************

TASK [Gathering Facts] ********************************************************
ok: [weltonauto.com]

TASK [install_nginx : Upgrade system] *****************************************
changed: [weltonauto.com]

TASK [install_nginx : Install nginx] ******************************************
changed: [weltonauto.com]

TASK [install_nginx : install letsencrypt] ************************************
changed: [weltonauto.com]

TASK [install_nginx : create letsencrypt directory] ***************************
changed: [weltonauto.com]

TASK [install_nginx : Remove default nginx config] ****************************
changed: [weltonauto.com]

TASK [install_nginx : Install system nginx default config] ********************
changed: [weltonauto.com]

TASK [install_nginx : Install letsencrypt config] *****************************
changed: [weltonauto.com]

TASK [install_nginx : Reload nginx to activate letsencrypt site] **************
changed: [weltonauto.com]

TASK [install_nginx : Create letsencrypt certificate main] ********************
changed: [weltonauto.com]

TASK [install_nginx : Create letsencrypt certificate gitlab] ******************
changed: [weltonauto.com]

TASK [install_nginx : Create letsencrypt certificate grafana] *****************
changed: [weltonauto.com]

TASK [install_nginx : Create letsencrypt certificate prometheus] **************
changed: [weltonauto.com]

TASK [install_nginx : Create letsencrypt certificate alertmanager] ************
changed: [weltonauto.com]

TASK [install_nginx : Generate dhparams] **************************************
changed: [weltonauto.com]

TASK [install_nginx : Install nginx site for specified site] ******************
changed: [weltonauto.com]

TASK [install_nginx : Reload nginx to activate specified site] ****************
changed: [weltonauto.com]

TASK [install_nginx : Add letsencrypt cronjob for cert renewal] ***************
changed: [weltonauto.com]

TASK [install_proxy : install privoxy] ****************************************
changed: [weltonauto.com]

TASK [install_proxy : configure privoxy] **************************************
changed: [weltonauto.com]

TASK [install_proxy : start privoxy] ******************************************
ok: [weltonauto.com]

RUNNING HANDLER [install_proxy : restart privoxy] *****************************
changed: [weltonauto.com]

PLAY RECAP ********************************************************************
weltonauto.com             : ok=22   changed=20   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

После этого пробуем зайти на любой сервер и получить 502, так как он еще не настроен. 

![alt text](img/3/502.png "502")

Так же обращаем внимание, что сертификат у нас не валидный, так как в режиме разработки проекта мы использовали --staging режим создания сертификатов. В дальнейшей работе после всех отладок мы будем использовать уже рабочий режим создания сертификатов. Для этого в роли мы уберем соотвествующий параметр.

![alt text](img/3/stage.png "stage")


4. Для установки кластера mysql используем плейбук ansible/mysql.yml. Он устанавливает на две наших виртуальных машины mysql сервера и собирает кластер master->slave. Так же добавляется пустая база wordpress для нашего проекта Wordpress, добавляется пользователь wordpress \ wordpress с полными правами на базу.

```
myagkikh@netology:~/devops_dip/tf$ ansible-playbook ../ansible/mysql.yml -i ../ansible/hosts

PLAY [mysql] ******************************************************************************

TASK [Gathering Facts] ********************************************************************
ok: [sql01.weltonauto.com]
ok: [sql02.weltonauto.com]

TASK [install_mysql : include_tasks] ******************************************************
included: /home/myagkikh/devops_dip/ansible/roles/install_mysql/tasks/variables.yml for sql01.weltonauto.com, sql02.weltonauto.com

TASK [install_mysql : Include OS-specific variables.] *************************************
ok: [sql01.weltonauto.com] => (item=/home/myagkikh/devops_dip/ansible/roles/install_mysql/vars/Debian.yml)
ok: [sql02.weltonauto.com] => (item=/home/myagkikh/devops_dip/ansible/roles/install_mysql/vars/Debian.yml)

TASK [install_mysql : Define mysql_packages.] *********************************************
ok: [sql01.weltonauto.com]
ok: [sql02.weltonauto.com]

TASK [install_mysql : Define mysql_daemon.] ***********************************************
ok: [sql01.weltonauto.com]
ok: [sql02.weltonauto.com]

TASK [install_mysql : Define mysql_slow_query_log_file.] **********************************
ok: [sql01.weltonauto.com]
ok: [sql02.weltonauto.com]

TASK [install_mysql : Define mysql_log_error.] ********************************************
ok: [sql01.weltonauto.com]
ok: [sql02.weltonauto.com]

TASK [install_mysql : Define mysql_syslog_tag.] *******************************************
ok: [sql01.weltonauto.com]
ok: [sql02.weltonauto.com]

TASK [install_mysql : Define mysql_pid_file.] *********************************************
ok: [sql01.weltonauto.com]
ok: [sql02.weltonauto.com]

TASK [install_mysql : Define mysql_config_file.] ******************************************
ok: [sql01.weltonauto.com]
ok: [sql02.weltonauto.com]

TASK [install_mysql : Define mysql_config_include_dir.] ***********************************
ok: [sql01.weltonauto.com]
ok: [sql02.weltonauto.com]

TASK [install_mysql : Define mysql_socket.] ***********************************************
ok: [sql01.weltonauto.com]
ok: [sql02.weltonauto.com]

TASK [install_mysql : Define mysql_supports_innodb_large_prefix.] *************************
ok: [sql01.weltonauto.com]
ok: [sql02.weltonauto.com]

TASK [install_mysql : include_tasks] ******************************************************
skipping: [sql01.weltonauto.com]
skipping: [sql02.weltonauto.com]

TASK [install_mysql : include_tasks] ******************************************************
included: /home/myagkikh/devops_dip/ansible/roles/install_mysql/tasks/setup-Debian.yml for sql01.weltonauto.com, sql02.weltonauto.com

TASK [install_mysql : Check if MySQL is already installed.] *******************************
ok: [sql01.weltonauto.com]
ok: [sql02.weltonauto.com]

TASK [install_mysql : Update apt cache if MySQL is not yet installed.] ********************
ok: [sql01.weltonauto.com]
ok: [sql02.weltonauto.com]

TASK [install_mysql : Ensure MySQL Python libraries are installed.] ***********************
changed: [sql01.weltonauto.com]
changed: [sql02.weltonauto.com]

TASK [install_mysql : Ensure MySQL packages are installed.] *******************************
changed: [sql02.weltonauto.com]
changed: [sql01.weltonauto.com]

TASK [install_mysql : Ensure MySQL is stopped after initial install.] *********************
changed: [sql01.weltonauto.com]
changed: [sql02.weltonauto.com]

TASK [install_mysql : Delete innodb log files created by apt package after initial install.] 
changed: [sql01.weltonauto.com] => (item=ib_logfile0)
changed: [sql02.weltonauto.com] => (item=ib_logfile0)
changed: [sql01.weltonauto.com] => (item=ib_logfile1)
changed: [sql02.weltonauto.com] => (item=ib_logfile1)

TASK [install_mysql : include_tasks] ******************************************************
skipping: [sql01.weltonauto.com]
skipping: [sql02.weltonauto.com]

TASK [install_mysql : Check if MySQL packages were installed.] ****************************
ok: [sql01.weltonauto.com]
ok: [sql02.weltonauto.com]

TASK [install_mysql : include_tasks] ******************************************************
included: /home/myagkikh/devops_dip/ansible/roles/install_mysql/tasks/configure.yml for sql01.weltonauto.com, sql02.weltonauto.com

TASK [install_mysql : Get MySQL version.] *************************************************
ok: [sql01.weltonauto.com]
ok: [sql02.weltonauto.com]

TASK [install_mysql : Copy my.cnf global MySQL configuration.] ****************************
changed: [sql01.weltonauto.com]
changed: [sql02.weltonauto.com]

TASK [install_mysql : Verify mysql include directory exists.] *****************************
skipping: [sql01.weltonauto.com]
skipping: [sql02.weltonauto.com]

TASK [install_mysql : Copy my.cnf override files into include directory.] *****************

TASK [install_mysql : Create slow query log file (if configured).] ************************
skipping: [sql01.weltonauto.com]
skipping: [sql02.weltonauto.com]

TASK [install_mysql : Create datadir if it does not exist] ********************************
changed: [sql01.weltonauto.com]
changed: [sql02.weltonauto.com]

TASK [install_mysql : Set ownership on slow query log file (if configured).] **************
skipping: [sql01.weltonauto.com]
skipping: [sql02.weltonauto.com]

TASK [install_mysql : Create error log file (if configured).] *****************************
skipping: [sql01.weltonauto.com]
skipping: [sql02.weltonauto.com]

TASK [install_mysql : Set ownership on error log file (if configured).] *******************
skipping: [sql01.weltonauto.com]
skipping: [sql02.weltonauto.com]

TASK [install_mysql : Ensure MySQL is started and enabled on boot.] ***********************
changed: [sql01.weltonauto.com]
changed: [sql02.weltonauto.com]

TASK [install_mysql : include_tasks] ******************************************************
included: /home/myagkikh/devops_dip/ansible/roles/install_mysql/tasks/secure-installation.yml for sql01.weltonauto.com, sql02.weltonauto.com

TASK [install_mysql : Ensure default user is present.] ************************************
changed: [sql01.weltonauto.com]
changed: [sql02.weltonauto.com]

TASK [install_mysql : Copy user-my.cnf file with password credentials.] *******************
changed: [sql01.weltonauto.com]
changed: [sql02.weltonauto.com]

TASK [install_mysql : Disallow root login remotely] ***************************************
ok: [sql01.weltonauto.com] => (item=DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1'))
ok: [sql02.weltonauto.com] => (item=DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1'))

TASK [install_mysql : Get list of hosts for the root user.] *******************************
ok: [sql01.weltonauto.com]
ok: [sql02.weltonauto.com]

TASK [install_mysql : Update MySQL root password for localhost root account (5.7.x).] *****
changed: [sql01.weltonauto.com] => (item=localhost)
changed: [sql02.weltonauto.com] => (item=localhost)

TASK [install_mysql : Update MySQL root password for localhost root account (< 5.7.x).] ***
skipping: [sql01.weltonauto.com] => (item=localhost)
skipping: [sql02.weltonauto.com] => (item=localhost)

TASK [install_mysql : Copy .my.cnf file with root password credentials.] ******************
changed: [sql01.weltonauto.com]
changed: [sql02.weltonauto.com]

TASK [install_mysql : Get list of hosts for the anonymous user.] **************************
ok: [sql01.weltonauto.com]
ok: [sql02.weltonauto.com]

TASK [install_mysql : Remove anonymous MySQL users.] **************************************

TASK [install_mysql : Remove MySQL test database.] ****************************************
ok: [sql01.weltonauto.com]
ok: [sql02.weltonauto.com]

TASK [install_mysql : include_tasks] ******************************************************
included: /home/myagkikh/devops_dip/ansible/roles/install_mysql/tasks/databases.yml for sql01.weltonauto.com, sql02.weltonauto.com

TASK [install_mysql : Ensure MySQL databases are present.] ********************************
changed: [sql01.weltonauto.com] => (item={'name': 'wordpress', 'collation': 'utf8_general_ci', 'encoding': 'utf8', 'replicate': 1})
changed: [sql02.weltonauto.com] => (item={'name': 'wordpress', 'collation': 'utf8_general_ci', 'encoding': 'utf8', 'replicate': 1})

TASK [install_mysql : include_tasks] ******************************************************
included: /home/myagkikh/devops_dip/ansible/roles/install_mysql/tasks/users.yml for sql01.weltonauto.com, sql02.weltonauto.com

TASK [install_mysql : Ensure MySQL users are present.] ************************************
changed: [sql01.weltonauto.com] => (item=None)
changed: [sql02.weltonauto.com] => (item=None)
changed: [sql01.weltonauto.com] => (item=None)
changed: [sql01.weltonauto.com]
changed: [sql02.weltonauto.com] => (item=None)
changed: [sql02.weltonauto.com]

TASK [install_mysql : include_tasks] ******************************************************
included: /home/myagkikh/devops_dip/ansible/roles/install_mysql/tasks/replication.yml for sql01.weltonauto.com, sql02.weltonauto.com

TASK [install_mysql : Ensure replication user exists on master.] **************************
skipping: [sql02.weltonauto.com]
changed: [sql01.weltonauto.com]

TASK [install_mysql : Check slave replication status.] ************************************
skipping: [sql01.weltonauto.com]
ok: [sql02.weltonauto.com]

TASK [install_mysql : Check master replication status.] ***********************************
skipping: [sql01.weltonauto.com]
ok: [sql02.weltonauto.com -> sql01.weltonauto.com]

TASK [install_mysql : Configure replication on the slave.] ********************************
skipping: [sql01.weltonauto.com]
changed: [sql02.weltonauto.com]

TASK [install_mysql : Start replication.] *************************************************
skipping: [sql01.weltonauto.com]
changed: [sql02.weltonauto.com]

RUNNING HANDLER [install_mysql : restart mysql] *******************************************
changed: [sql02.weltonauto.com]
changed: [sql01.weltonauto.com]

PLAY RECAP ********************************************************************************
sql01.weltonauto.com       : ok=42   changed=15   unreachable=0    failed=0    skipped=14   rescued=0    ignored=0
sql02.weltonauto.com       : ok=45   changed=16   unreachable=0    failed=0    skipped=11   rescued=0    ignored=0
```

После установки зайдем в консоль sql и посмотрим на работоспособность реплики и наличие базы на мастер сервере.

![alt text](img/4/master.png "master")

![alt text](img/4/slave.png "slave")

![alt text](img/4/replica_state.png "state")

5. Для установки Wordpress на наш сервер приложений используем плейбук ansible/app.yml. Он сочетает 4 роли, nginx, memcache, php7, wordpress. Все это дело устанавливается на сервер. 

```
myagkikh@netology:~/devops_dip/tf$ ansible-playbook ../ansible/app.yml -i ../ansible/hosts

PLAY [app] ********************************************************************************

TASK [Gathering Facts] ********************************************************************
ok: [app.weltonauto.com]

TASK [nginx : Install nginx] **************************************************************
ok: [app.weltonauto.com]

TASK [nginx : Disable default site] *******************************************************
ok: [app.weltonauto.com]

TASK [memcached : install memcached server] ***********************************************
ok: [app.weltonauto.com]

TASK [php : Upgrade system] ***************************************************************
ok: [app.weltonauto.com]

TASK [php : install php7.4] ***************************************************************
ok: [app.weltonauto.com]

TASK [php : change listen socket] *********************************************************
ok: [app.weltonauto.com]

TASK [wordpress : Install git] ************************************************************
ok: [app.weltonauto.com]

TASK [wordpress : install nginx configuration] ********************************************
ok: [app.weltonauto.com]

TASK [wordpress : activate site configuration] ********************************************
ok: [app.weltonauto.com]

TASK [wordpress : download WordPress] *****************************************************
ok: [app.weltonauto.com]

TASK [wordpress : creating directory for WordPress] ***************************************
ok: [app.weltonauto.com]

TASK [wordpress : unpack WordPress installation] ******************************************
changed: [app.weltonauto.com]

TASK [wordpress : wordpress php] **********************************************************
changed: [app.weltonauto.com]

PLAY RECAP ********************************************************************************
app.weltonauto.com         : ok=14   changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```


После установки можно зайти на него по адресу https://www.weltonauto.com и увидеть приветственную страницу Wordpress.

![alt text](img/5/wordpress2.png "wp2")

![alt text](img/4/wordpress.png "wp")