#!/usr/bin/env python
#This script use to test the url by check http code 404.
#Edit hosts before running,that will avoid network latency. 

import requests

test_file = '/usr/local/sbin/404/All'
log_file = '/usr/local/sbin/404/error'

with open (log_file, 'w') as l:
    l.truncate()
    l.close()

with open(test_file) as f:
    for url in f.readlines():
        url = url.strip()
        results = requests.get(url, timeout=1)

        if results.status_code == 404:
            with open(log_file, 'a') as l:
                l.write(str(results.status_code) + ' ' + url + '\n\n')
    l.close()
f.close()
