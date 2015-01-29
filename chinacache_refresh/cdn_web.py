#!/usr/bin/env python
# This script apply to ChinaCache's v4.5 api only.
#Change XXX to your domain

import os
import datetime
import pyinotify
import logging
import re
import subprocess

USER = 'YOUR_USERNAME'
PWD = 'YOUR_PASSWORD'               #api password not portal's
LOG = '/data/logs/cdn/cdn.log'

class PushCDN(pyinotify.ProcessEvent):
	logger = logging.getLogger()
	logger.setLevel(logging.INFO)
	handler = logging.FileHandler("/data/logs/cdn/cdn_pyinotify.log")
	handler.setLevel(logging.INFO)
	logger.addHandler(handler)

	def process_IN_MOVED_TO(self, event):
		channel = event.pathname.split('/')
		m = ['brand', 'auto', 'timepiece', 'jewelry', 'fashion', 'healthbeauty', 'admiration', \
			 'jetyacht', 'lifestyle', 'elite', 'viewpoint', 'activity', 'club', 'industry', 'trip']
		if channel[5] in m:
			url = re.sub(r'/data/www/wwwroot/w/\w+/', 'http://%s.XXX.com/', event.pathname) % channel[5]
		elif channel[5] == 'gou':
			url = re.sub(r'/data/www/wwwroot/r/', 'http://r.XXX.com/', event.pathname)
		elif channel[4] == 'r' and channel[5] != 'gou':
			url = re.sub(r'/data/www/wwwroot/', 'http://www.XXX.com/', event.pathname)
		elif channel[4] == 'w' and channel[5] != 'home':
			url = re.sub(r'/data/www/wwwroot/w/', 'http://www.XXX.com/', event.pathname)
		elif channel[4] == 'u' and channel[5] != 'gou':
			url = re.sub(r'/data/www/wwwroot/u/', 'http://img.XXX.com/', event.pathname)
		elif channel[4] == 'weixin':
			url = re.sub(r'/data/www/wwwroot/weixin/', 'http://weixin.XXX.com/', event.pathname)
		elif channel[6] == 'video':
			url = re.sub(r'/data/www/wwwroot/w/home/video/', 'http://video.XXX.com/', event.pathname)
		elif channel[6] == 'HomeFocus':
			url = re.sub(r'/data/www/wwwroot/w/home/', 'http://www.XXX.com/', event.pathname)
		subprocess.call('curl -d "user=%s&pswd=%s&ok=ok&urls=%s" -s http://ccms.chinacache.com/index.jsp' % (USER, PWD, url), shell=True, stdout=open('/dev/null','w'), stderr=subprocess.STDOUT)       
		logging.info("%s - %s - %s" % (datetime.datetime.now().strftime( '%Y-%m-%d %H:%M:%S' ), event.pathname, url))
		
def main():
	wm = pyinotify.WatchManager()
	wm.add_watch('/data/www/wwwroot', pyinotify.IN_MOVED_TO, rec=True)
	push_to_cdn = PushCDN()
	notifier = pyinotify.Notifier(wm, push_to_cdn)
	notifier.loop()

if __name__ == '__main__':
    main()
