#!/usr/bin/python

import bmemcached
import random
import urllib2
import os

channel = 'All'

#aliyun ocs info
ip = 'YOUR_OCS_ADDRESS'
port = '11211'
user = 'YOUR_OCS_USERNAME'
passwd = 'YOUR_OCS_PASSWD'

client = bmemcached.Client((ip + ':' + port), user, passwd)
max = os.popen("wc -l /data/www/wwwroot/luxtarget/php/interface/tools/geturl/All|awk '{print $1}'").read()
key = channel + str(random.randint(0,int(max)))
url = client.get(key)
print url
