#!/usr/bin/env python

import pycurl
import StringIO
import sys

test_file = '/usr/local/sbin/404/All'
log_file = '/usr/local/sbin/404/error'

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
					l.close()
			print r,url
		except pycurl.error,e:
			with open(log_file, 'a') as l:
				l.write('error' + ' ' + url + ' ' + str(e) + '\n\n')
				l.close()
			pass
