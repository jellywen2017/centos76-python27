#!/bin/sh
#########################################################################
# File Name: start.sh
# Author: jellywen
# Email:  1307553378@qq.com
# Version:
# Created Time: 2019/03/01
#########################################################################

Nginx_Install_Dir=/usr/local/nginx
DATA_DIR=/data/www

#启动crond
/usr/sbin/crond start
/bin/bash
#开启nginx php-fpm 服务
#/usr/bin/supervisord -n -c /etc/supervisord.conf
