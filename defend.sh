#!/bin/bash
#
#********************************************************************
#Author:                zcl
#QQ:                    no qq number
#Date:                  2018-10-19
#FileName：             DefendDosAttack.sh
#URL:                   https://www.minsv.com
#Description：          The script name
#Copyright (C):         2018 All rights reserved
#********************************************************************

# 检查并发连接数量，写入concurrence文件
netstat -anl | grep .*:443.*ESTABLISHED | gawk -F ' ' '{ print $5 }' | gawk -F: '{ print $1 }' | sort | uniq -c &> concurrence

# 从文件中拿到IP地址相应的并发数，如果并发数量超过20，执行iptables deny.
cat /root/concurrence | while read line
do
    num=`echo $line | gawk -F ' ' '{ print $1 }'`;
    ip=`echo $line | gawk -F ' ' '{ print $2 }'`;
    echo "The concurrences of ip addr $ip :$num" &>> attack.txt
    if [ $num -gt 20 ]
    then
        echo "`date '+%F %T'`  The ip $ip is attacking." &>> attack.txt
        /usr/sbin/iptables -A INPUT -s $ip -j DROP;
    fi
done
