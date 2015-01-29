#!/bin/bash
#mysql backup
#date:2012.02.24
#editor:mayiwei

USER='YOUR_MySQL_USERNAME'
PWD='YOUR_MySQL_PASSWORD'
DATE=`date -d yesterday +%Y-%m-%d`

#for innodb
/usr/local/mysql/bin/mysqldump -u$USER -p$PWD --default-character-set=utf8 --opt --extended-insert=false --triggers -R --hex-blob --single-transaction --all-databases > /data/backup/db-$DATE.sql
#for myisam
/usr/local/mysql/bin/mysqldump -u$USER -p$PWD --default-character-set=utf8 --opt --extended-insert=false --triggers -R --hex-blob -x --all-databases > /data/backup/db-$DATE.sql
/bin/tar czf /data/backup/db-$DATE.tar.gz /data/backup/db-$DATE.sql && rm -rf /data/backup/db-$DATE.sql
/usr/bin/find /data/backup -name "db-*.tar.gz" -mtime +6 -exec rm -rf {} \;
