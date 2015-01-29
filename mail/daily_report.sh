#!/bin/bash

#   editor : mayiwei
#     date : 2012.12.20
# function : report backup status

/usr/sbin/sendmail -t <<EOF
From: xxx.xxx.xxx.xxx <mayiwei@targetmag.com.cn>
To: Ma Yiwei <mayiwei@targetmag.com.cn>
Subject: cms daily report
MIME-Version: 1.0
Content-Type: text/html

<html> 
<head>
</head>
<body>
<b>CMS Backup Report:</b><br />
`du -sh /data/backup/*|sed 's/$/&<br \/>/'`
<br />
<br />
<b>CMS Rkhunter Report:</b><br />
`/usr/local/bin/rkhunter -c --sk -l --nomow --rwo|sed 's/$/&<br \/>/'`
</body>
</html>
EOF
