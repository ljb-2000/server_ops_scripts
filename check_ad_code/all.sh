#!/bin/bash
#Change XXX to your domain

channel="brand jetyacht healthbeauty lifestyle elite timepiece jewelry admiration fashion auto video activity viewpoint industry"

while read url
do
    for i in $channel
    do
        sed "s/http:\/\/$i\.XXX\.com/\/data\/www\/wwwroot\/w\/$i/" $url
        #[[ -n `grep '1017947' $i` ]] && echo $i >> all_ok
        echo $url
    done

    #sed -i 's/video/home\/video/' All

done < All
