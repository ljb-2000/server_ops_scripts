#!/usr/bin/env python
#html backup
#date:2014.10.11
#editor:mayiwei

from oss.oss_api import *
from datetime import *
import subprocess
import urllib2

log_date = (date.today() - timedelta(2)).strftime("%Y%m%d")
host = "YOUR_OSS_PASSWD"
access_id = "YOUR_ID"
access_key = "YOUR_KEY"
bucket = "YOUR_BUCKET_NAME"
cc_name = "YOUR_CC_USERNAME"
cc_pwd = "YOUR_CC_PASSWORD"

oss=OssAPI(host, access_id, access_key)

def bak():
	channels = {'XXXXX':'news'}
	
	for channel in channels.keys():
		log_api = "http://logcenter.chinacache.com/URLGetter?username=%s&password=%s&date=%s&channelId=%s" % (cc_name, cc_pwd, log_date, channel)
		try:
			req = urllib2.Request(log_api)
			response = urllib2.urlopen(req)
			dl_url = response.read()
			f = urllib2.urlopen(dl_url)
			with open("/data/logs/cc/%s_%s_w3c.gz" % (channels[channel], log_date), "wb") as code:
				code.write(f.read())

			object = "%s/%s_%s_w3c.gz" % (log_date, channels[channel], log_date)
			file = "/data/logs/cc/%s_%s_w3c.gz" % (channels[channel], log_date)
			res = oss.multi_upload_file(bucket, object, file, max_part_num=1000)
			
			if res.status == 200:
				subprocess.call("rm -rf %s" %file, shell=True)

		except ValueError:
			error_log = open("/data/logs/cc/_error_%s" % channels[channel], "w")
			error_log.write("Error _ channel: %s _ date: %s" % (channels[channel], log_date))
			error_log.close
			object_error = "%s/_error_%s" % (log_date, channels[channel])
			file_error = "/data/logs/cc/_error_%s" % channels[channel]
			res = oss.put_object_from_file(bucket, object_error, file_error) #for small file upload
			if res.status == 200:
				subprocess.call("rm -rf %s" %file_error, shell=True)
			continue

if __name__ == '__main__':
	bak()
