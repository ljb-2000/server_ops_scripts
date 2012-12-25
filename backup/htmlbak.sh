#!/bin/bash
#html backup
#date:2012.02.24
#editor:mayiwei

DATE=`date +%y-%m-%d-%H`

cd /data/www/wwwroot
tar cvzf html$DATE.tar.gz *
mv html$DATE.tar.gz /data/backup
/usr/bin/find /data/backup -name "html*.tar.gz" -mtime +6 -exec rm -rf {} \;