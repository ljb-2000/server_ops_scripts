#!/bin/bash

#   editor : mayiwei
#     date : 2014.09.28
# function : report backup status

date_now=`date +%s`
date_s1=`stat -c %Y /data/anjian/account1.xlsx`
date_s2=`stat -c %Y /data/anjian/account2.xlsx`
last1=`expr $date_now - $date_s1`
last2=`expr $date_now - $date_s2`

mail()
{

/usr/sbin/sendmail -t <<EOF
From: Office <mayiwei@targetmag.com.cn>
To: Zhao Xinmeng <zhaoxinmeng@targetmag.com.cn>
Subject: 
Content-Type: text/html ; charset=utf-8

<b>服务器:</b> $server<br/>
<b>当前时间:</b> `date '+%Y-%m-%d %H:%M:%S'`<br/>
<b>日志文件最后一次修改时间:</b> `stat -c %y /data/anjian/account2.xlsx|awk -F. '{print $1}'`<br/>

EOF

}

if [ $last1 -gt 600 ];then
  server='192.168.1.14'
  mail
fi

if [ $last2 -gt 600 ];then
  server='192.168.1.11'
  mail
fi
