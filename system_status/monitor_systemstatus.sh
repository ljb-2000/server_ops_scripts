#!/bin/bash

IP=192.168.1.1
top -n 2| grep "Cpu" >>./temp/cpu.txt
free -m | grep "Mem" >> ./temp/mem.txt
df -k | grep "sda1" >> ./temp/drive_sda1.txt
time=`date +%m"."%d" "%k":"%M`
connect=`netstat -na | grep "219.238.148.30:80" | wc -l`
echo "$time  $connect" >> ./temp/connect_count.txt