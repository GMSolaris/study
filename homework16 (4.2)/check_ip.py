#!/usr/bin/env python3

import socket
import time
import datetime


i = 1
timeout = 2 
host_list = {'drive.google.com':'0.0.0.0', 'mail.google.com':'0.0.0.0', 'google.com':'0.0.0.0'}
init=0


print("Script started")
print(host_list)


while 1==1 : #отладочное число проверок 
  for host in host_list:
    ip = socket.gethostbyname(host)
    if ip != host_list[host]:
      if i==1 and init !=0:
        print(str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")) +' [ERROR] ' + str(host) +' IP mistmatch: '+host_list[host]+' '+ip)
      host_list[host]=ip
  init+=1
  time.sleep(timeout)