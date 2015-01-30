#!/usr/bin/env python
# This script apply to ChinaCache's v5.2 api only.
#Change XXX to your domain

import os
import pyinotify
import re
import requests
import json
import datetime

def push_to_cdn(url):

    values = {"username":api_username, "password":api_password, "task":{"urls":[url]}}
    requests.post(api_address, data=json.dumps(values))
    
    with open("/data/logs/cdn/cdn.log-%s" % datetime.date.today(), 'a') as f:
        f.write(" URL: %s\nTIME: %s\n\n" % (url, datetime.datetime.now()))
    
class EventHandler(pyinotify.ProcessEvent):
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

        push_to_cdn(url)
        
def monitor():
    wm = pyinotify.WatchManager()
    wm.add_watch('/data/www/wwwroot', pyinotify.IN_MOVED_TO, rec=True)
    notifier = pyinotify.Notifier(wm, EventHandler())
    notifier.loop()

if __name__ == '__main__':
    api_username = ''
    api_password = ''
    api_address = 'https://r.chinacache.com/content/refresh'
    monitor()
