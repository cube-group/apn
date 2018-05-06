# apn
[![Latest Stable Version](https://poser.pugx.org/cube-group/base-image-apn/version)](https://hub.docker.com/r/lin2798003/apn/)

用途：php项目进行自动化crontab任务
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
项目根目录(即/var/www/html目录)包含cron.json
### 环境变量支持
* APP_NAME 项目名称
* APP_PATH 项目目录（默认为/var/www/html)
* APP_MONITOR_HOOK 钉钉报警机器人地址（默认为空）
