#!/bin/bash

# Increase the memory_limit
if [ ! -z "$PHP_MEM_LIMIT" ]; then
 sed -i "s/memory_limit = -1/memory_limit = ${PHP_MEM_LIMIT};/g" /etc/php/7.1/cli/php.ini
fi

# Increase the memory_limit
if [ ! -z "$PHP_POST_MAX_SIZE" ]; then
 sed -i "s/post_max_size = 8M/post_max_size = ${PHP_POST_MAX_SIZE};/g" /etc/php/7.1/cli/php.ini
fi

# Increase the memory_limit
if [ ! -z "$PHP_UPLOAD_MAX_FILESIZE" ]; then
 sed -i "s/upload_max_filesize = 2M/upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE};/g" /etc/php/7.1/cli/php.ini
fi

node /extra/monitor/start




