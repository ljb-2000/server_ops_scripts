#!/bin/bash
#log backup
#date:2012.02.24
#editor:mayiwei

DATE=`date --date=yesterday +%y-%m-%d-%H`

cd /data/log/apachelog/
mv access_log access_log$DATE
mv error_log error_log$DATE
tar czvf access_log$DATE.tar access_log$DATE
rm -f error_log$DATE
/usr/local/apache/bin/apachectl restart
