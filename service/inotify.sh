#!/bin/sh

SRC=/data/www/wwwroot/XXX/java/u/
DES=img
WEB=192.168.1.114
USER=www

/usr/local/bin/inotifywait -mrq -e create,move,delete,modify,attrib $SRC | while read X Y Z
do
/usr/local/bin/rsync -avz $SRC --delete $USER@$WEB::$DES
done

