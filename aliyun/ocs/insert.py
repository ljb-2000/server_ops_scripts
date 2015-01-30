#!/usr/bin/python

import bmemcached
import random
import urllib2
import webbrowser
import time

channel = 'All'
ip = 'YOUR_OCS_ADDRESS'
port = '11211'
user = 'YOUR_OCS_USERNAME'
passwd = 'YOUR_OCS_PASSWD'
max = 1

client = bmemcached.Client((ip + ':' + port), user, passwd)

for line in open('/usr/local/sbin/All'):
    value = line.strip()
    key = 'All' + str(max)
    client.set(key,value)
    max = max + 1
    time.sleep(0.001)
