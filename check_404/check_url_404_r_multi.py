#!/usr/bin/env python
#This script use to test the url by check http code 404.
#Edit hosts before running,that will avoid network latency. 

import requests
from multiprocessing import Pool
from multiprocessing.dummy import Pool as ThreadPool

test_file = '/usr/local/sbin/404/All'
log_file = '/usr/local/sbin/404/error'

def get_code(url):
	result = requests.get(url, timeout=1)
	if result.status_code == 404:
		with open(log_file, 'a') as l:
			l.write(str(result.status_code) + ' ' + url + '\n\n')

if __name__ == '__main__':
	with open (log_file, 'w') as l:
		l.truncate()
		l.close()
	
	urls = []
	
	with open(test_file) as f:
		for url in f.readlines():
			url = url.strip()
			urls.append(url)
	
	pool = ThreadPool(processes=4)
	pool.map(get_code, urls)
	
	l.close()
	f.close()
