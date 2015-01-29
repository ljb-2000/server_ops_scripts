#!/usr/bin/env python
# mayiwei 2014.12.10
# this script using to check advertising code by keyword
#Change XXX to your domain

import re
import subprocess

test_file = raw_input('test FILE is: ')
test_code = raw_input('test CODE is: ')
ok_log = '/usr/local/sbin/check_ad_code/log_ok_%s' % test_file
error_log = '/usr/local/sbin/check_ad_code/log_error_%s' % test_file
dict = {}

#empty the log file
with open (ok_log, 'w') as ok:
	ok.truncate()
	ok.close()

with open (error_log, 'w') as error:
	error.truncate()
	error.close()

f = open('%s' % test_file)

for url in f.readlines():
	url = url.strip('')
	channel = url[7:].split('.')[0]
	url = re.sub(r'/$', '/index.html', url)

	if channel == 'video':
		file = re.sub(r'http://video.XXX.com/', '/data/www/wwwroot/w/home/video/', url)
	else:
		file = re.sub(r'http://(\w+).XXX.com/', '/data/www/wwwroot/w/%s/', url) % channel
	
	dict = {file:url}

	subprocess.call('[[ -n `grep %s %s` ]] && echo %s >> %s || echo %s >> %s' % (test_code, file, dict.get(file), ok_log, dict.get(file), error_log), shell=True)
