#!/usr/bin/python
#html backup
#date:2014.06.11
#editor:mayiwei

from oss.oss_api import *
from datetime import *
import subprocess

DATE=date.today()
PREFIX = (DATE - timedelta(7)).strftime("%Y-%m-%d")
HOST="YOUR_OSS_PASSWD"
ACCESS_ID="YOUR_ID"
ACCESS_KEY="YOUR_KEY"
BUCKET="YOUR_BUCKET_NAME"

oss=OssAPI(HOST, ACCESS_ID, ACCESS_KEY)

def bak():
	source_dir="/data/www/wwwroot/"
	backup_dir="/data/backup/"
	backup_file="app-html-%s.tar.gz" %DATE
	object="%s/app-html-%s.tar.gz" % (DATE, DATE)
	file=backup_dir + backup_file

	subprocess.call("tar zcf %s %s" % (file, source_dir), shell=True)

	res=oss.put_object_from_file(BUCKET, object, file) #for small file upload
	#res = oss.multi_upload_file(bucket, object, file, max_part_num=1000) #for large file upload

	if res.status == 200:
		subprocess.call("rm -rf %s" %file, shell=True)

def delete():
	object_list=oss.list_objects(BUCKET, PREFIX)
	oss.batch_delete_objects(BUCKET, object_list)

if __name__ == '__main__':
	bak()
	delete()
