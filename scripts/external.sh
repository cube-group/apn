#!/bin/sh

#启动初始化shell
php /extra/monitor/init.php >> /cli.log &
#启动node脚本
node /extra/monitor/start.js >> /cli.log &

