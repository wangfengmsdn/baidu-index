#!/bin/sh
SERVICE=/home/wangfeng/baidu-index/baidutest.rb
SERVICE_STATUS=`ps -ef | grep -v grep|grep $SERVICE`
LOG_FILE=/home/wangfeng/baidu-index/service_mon.log
if [ "$SERVICE_STATUS"x == ""x ]
then
        echo "$SERVICE process is not running... start it " >> $LOG_FILE
	ruby /home/wangfeng/baidu-index/baidutest.rb nohup&	
else
        echo "$SERVICE process is running..." >> $LOG_FILE
fi
