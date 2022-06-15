Все действия делались в собственном гитлабе.

Ссылка на репозиторий
https://git.rs-app.ru/myagkikh/test

Результат запуска контейнера после исправления

```
root@dev:~# docker run -itd -p 5290:5290 git.rs-app.ru:5050/myagkikh/test/python_api
e4161a2534543d56b2275e3c0155138bcb7a3dd58f15891ef9028eff111aa8ef
root@dev:~# docker ps
CONTAINER ID   IMAGE                                         COMMAND                  CREATED         STATUS         PORTS                                       NAMES
e4161a253454   git.rs-app.ru:5050/myagkikh/test/python_api   "python3 /python_api…"   3 seconds ago   Up 2 seconds   0.0.0.0:5290->5290/tcp, :::5290->5290/tcp   awesome_ardinghelli
root@dev:~# curl localhost:5290/get_info
{"version": 3, "method": "GET", "message": "Running"}
```

