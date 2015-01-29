#!/bin/bash 
ftp -n<<! 
open xxx.xxx.xxx.xxx
user USERNAME PASSWORD
binary  
lcd /var/www/html
prompt 
mget sitemap*
close 
bye 
!
