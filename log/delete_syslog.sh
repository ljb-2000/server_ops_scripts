#!/bin/bash
#delete old syslog
#date:2012.02.24
#editor:mayiwei

USER=''
PWD=''
MesDate=`date -d '30 days ago' +%Y-%m-%d`
SqlDate=`date -d '-1 week' +%m-%d`
Mes=/www/messages

mysql -u$USER -p$PWD -e "delete from Syslog.SystemEvents where DATE_FORMAT(DeviceReportedTime,'%m-%d') like '%$SqlDate%';"
sed -i "/$MesDate/d" $Mes
