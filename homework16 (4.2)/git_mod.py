#!/usr/bin/env python3

import os
import sys

input_path = sys.argv[1]


bash_command = ["cd "+input_path, "git status 2>&1"]
result_os = os.popen(' && '.join(bash_command)).read()


path_to_file=(bash_command[0])
correct_path_to_file=path_to_file.replace("cd ", "")
for result in result_os.split('\n'):
    if result.find('fatal') != -1:
        print('Not a git repository  ----> '+input_path)    
    if result.find('modified') != -1:
        prepare_result = os.path.expanduser(result.replace('\tmodified:   ', correct_path_to_file))
        print(prepare_result.replace('..', ''))