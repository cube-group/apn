# apn
docker hub地址: https://hub.docker.com/r/lin2798003/apn

用途：
* 项目进行自动化crontab任务
* 项目进行持久化脚本

### linux
alpine:3.7
### php7
php:7.2
### nodejs
node:6*
### php扩展支持
```
[PHP Modules]
amqp
apcu
Core
ctype
curl
date
dom
exif
fileinfo
filter
ftp
gd
gettext
hash
iconv
igbinary
intl
json
libxml
mbstring
memcached
mongodb
msgpack
mysqlnd
openssl
pcre
PDO
pdo_mysql
pdo_pgsql
pdo_sqlite
Phar
posix
readline
Reflection
session
SimpleXML
soap
sodium
SPL
sqlite3
standard
tokenizer
xml
xmlreader
xmlwriter
xsl
yaf
Zend OPcache
zip
zlib

[Zend Modules]
Zend OPcache
```
### opcache
自动开启且不进行定时检测
### cron支持
项目根目录(即/var/www/html目录)包含cron.json格式如下:
可以支持到秒级也可以使用分钟级别
```json
{
  "hook": "",
  "jobs": [
    {
      "time": "* * * * * *",
      "value": "echo hello"
    },
    {
      "time": "*/10 * * * * *",
      "value": "php $APP_PATH/think module/controller/action"
    }
  ]
}
```

## 环境变量:PHP参数相关
* PHP_MEM_LIMIT: php进程内存限制,默认512M
* PHP_POST_MAX_SIZE: php post最大字节 默认100M
* PHP_UPLOAD_MAX_FILESIZE: php最大文件上传限制 默认100M

## 特殊环境变量
* APP_NAME: app名称
* APP_PATH: 项目所在目录(默认为:/var/www/html)
* APP_MONITOR_HOOK: app报警钉钉群机器人webhook

## 特殊入口脚本支持
Dockerfile中追加<br>
```Dockerfile
RUN echo "php a/b/c >> /cli.log &" >> /extra/external.sh
```
注意:脚本一定都需要是在系统后台运行
