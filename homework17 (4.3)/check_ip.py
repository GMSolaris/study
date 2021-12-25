#!/usr/bin/env python3

# import libs
import socket
import time
import datetime
import json
import yaml

# variables
i = 1
timeout = 2
host_list = {'api.mxgroup.ru': '0.0.0.0', 'new.mxgroup.ru': '0.0.0.0', 'm.mxgroup.ru': '0.0.0.0'}
init = 0

print("Script started")
print(host_list)

while 1 == 1:
    for host in host_list:
        ip = socket.gethostbyname(host)
        if ip != host_list[host]:
            if i == 1 and init != 0:
                print(str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")) + ' [ERROR] ' + str(
                    host) + ' IP mistmatch: ' + host_list[host] + ' ' + ip)
            host_list[host] = ip
    init += 1
    # json file save
    jsonString = json.dumps(host_list)
    jsonFile = open("services.json", "w")
    jsonFile.write(jsonString)
    jsonFile.close()
    # yaml file save
    with open('services.yaml', 'w') as file:
        yaml.dump(host_list, file, default_flow_style=False)
    time.sleep(timeout)
