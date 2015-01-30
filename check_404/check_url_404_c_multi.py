#!/usr/bin/env python
#This script use to test the url by check http code 404.
#Edit hosts before running,that will avoid network latency. 

import pycurl
import StringIO
import sys
from multiprocessing import Pool
from multiprocessing.dummy import Pool as ThreadPool

test_file = '/usr/local/sbin/404/All'
log_file = '/usr/local/sbin/404/error'

#empty the log file
with open (log_file, 'w') as l:
    l.truncate()
    l.close()

#config pycurl
def get_code(url):      
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

if __name__ == '__main__':
    urls = []
    
    with open(test_file) as f:
        for url in f.readlines():
            url = url.strip()
            urls.append(url)
            
    pool = ThreadPool(processes=2)
    pool.map(get_code, urls)
    pool.close() #关闭pool，使其不在接受新的任务
    pool.join()  #主进程阻塞等待子进程的退出， join方法要在close或terminate之后使用
    f.close()
    l.close()   
