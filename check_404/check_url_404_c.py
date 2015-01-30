#!/usr/bin/env python
#This script use to test the url by check http code 404.
#Edit hosts before running,that will avoid network latency. 

import pycurl
import StringIO
import sys

test_file = '/usr/local/sbin/404/All'
log_file = '/usr/local/sbin/404/error'

with open (log_file, 'w') as l:
    l.truncate()
    l.close()

with open(test_file) as f:
    for url in f.readlines():
        url = url.strip()
        
        try:
            c = pycurl.Curl()
            b = StringIO.StringIO()
            c.setopt(pycurl.URL, url)
            c.setopt(pycurl.WRITEFUNCTION, b.write)
            c.setopt(pycurl.FOLLOWLOCATION, 1)
            c.setopt(pycurl.MAXREDIRS, 5)
            c.setopt(pycurl.CONNECTTIMEOUT, 1)
            c.setopt(pycurl.TIMEOUT, 1)
            c.perform()
        
            r = c.getinfo(c.HTTP_CODE)
        
            if r == 404:
                with open(log_file, 'a') as l:
                    l.write(str(r) + ' ' + url + '\n\n')
        except pycurl.error,e:
            with open(log_file, 'a') as l:
                l.write('error' + ' ' + url + ' ' + str(e) + '\n\n')
            pass
    l.close()
f.close()
