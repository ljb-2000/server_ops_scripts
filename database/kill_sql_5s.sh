#!/bin/bash

port=53
if [ $port'z' == 'z' ]
then
  port=3306
fi

mysql -h${1} -P${port} -e "select * from information_schema.processlist where info is not null and time>${2} and user like '%dbreader' and info like '%select%'\G">.sql.${1}.tmp

pids=`mysql -h{$1} -P${port} -e "select id from information_schema.processlist where info is not null and time >${2} and user like '%dbreader%' and info like '%select%'"|awk -F\| '{printf $1"\n"}'`

if [ -s .sql.${1}.tmp ];then
  date +"%Y%M%D %H:%m:%S">>${1}_1.log
  cat .sql.${1}.tmp>>${1}_1.log
fi
for i in $pids" 0"
do
  echo "${i}";
  mysql -h${1} -P${port} -e "kill $i;" 1>/dev/null 2>/dev/null
done
echo -e "\n";
