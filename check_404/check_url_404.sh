#! /bin/bash
#This script use to test the url by check http code 404.
#Edit hosts before running,that will avoid network latency. 

success=0
failure=0
total=0
code="200"
dir=/usr/local/sbin/ad

for url in `cat /usr/local/sbin/ad/All_ok`;do
    total=`expr $total + 1`
    b=`curl -I $url -s | head -1 | awk '{print$2}'`
    if [[ $b -ne $code ]];then
        echo $url >> $dir/failure.log
        curl -I $url -s|head -n1 >> $dir/failure.log
        failure=`expr $failure + 1`
    else
        success=`expr $success + 1`
    fi;
done
echo total=$total >>  $dir/info.log
echo success=$success >>  $dir/info.log
echo failure=$failure >>  $dir/info.log
