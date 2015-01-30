#!/bin/bash
#Change XXX to your domain


SRC=/data/www/wwwroot
USER='YOUR_USERNAME'
PWD='YOUR_PASSWORD'         #api password not portal's
LOG=/data/logs/cc_refresh

/usr/local/bin/inotifywait -mrq -e modify --timefmt '%Y-%m-%d %H:%M:%S' --format '%w%f %T' $SRC | while read A B
do
    for x in `echo $A|awk -F/ '{print $5,$6,$7}'`
    do
        [ $x = brand -o $x = auto -o $x = timepiece -o $x = jewelry -o $x = fashion -o $x = healthbeauty -o $x = admiration -o $x = jetyacht -o $x = lifestyle -o $x = elite -o $x = viewpoint -o $x = activity -o $x = club -o $x = industry ] && line=`echo $A|sed -e "s/\.//" -e "s/.......$//" -e "s/\/data\/www\/wwwroot\/w\/$x/http:\/\/$x.XXX.com/"`
        [ $x = video ] && line=`echo $A|sed -e "s/\.//" -e "s/.......$//" -e "s/\/data\/www\/wwwroot\/w\/home\/video/http:\/\/video.XXX.com/"`
        [ $x = HomeFocus ] && line=`echo $A|sed -e "s/\.//" -e "s/.......$//" -e "s/\/data\/www\/wwwroot\/w\/HomeFocus/http:\/\/www.XXX.com\/HomeFocus/"`
        [ $x = u ] && line=`echo $A|sed -e "s/\.//" -e "s/.......$//" -e "s/\/data\/www\/wwwroot\/u/http:\/\/img.XXX.com/"`
        [ $x = r ] && line=`echo $A|sed -e "s/\.//" -e "s/.......$//" -e "s/\/data\/www\/wwwroot/http:\/\/www.XXX.com/"`
    done
    curl -d "user=$USER&pswd=$PWD&ok=ok&urls=$line" -s http://ccms.chinacache.com/index.jsp > /dev/null 2>&1
    echo $B $line >> $LOG
done