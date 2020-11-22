# 简介
本套环境利用docker-compose搭建，安装后可以直接运行php项目。

目前包含mysql、mongo、redis、kafka、rabbitmq、elasticsearch、php5、php7、nginx镜像，其中php5和php7镜像集成了xhprof和xhgui，可用于分析php程序性能。

# 环境依赖
## Docker
OSX：[下载地址1](https://download.docker.com/mac/stable/Docker.dmg) [下载地址2](https://dn-dao-github-mirror.qbox.me/docker/install/mac/Docker.dmg)

Windows：[下载地址1](https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe) [下载地址2](https://dn-dao-github-mirror.qbox.me/docker/install/windows/InstallDocker.msi)

Linux：略

## Git
OSX：[下载地址](https://git-scm.com/download/mac)

Windows：[下载地址](https://git-scm.com/download/win)

Linux：略

# 环境安装
## 环境准备
```
cd /tmp
git clone git@github.com:raw34/docker-lnmp.git
cd docker-lnmp
source .env
```

## 目录创建
需要准备一些本地目录，可以通过修改.env文件中的变量声明调整目录。
```
mkdir -p ${PATH_WWW_ROOT}/repo \
mkdir -p ${PATH_WWW_ETC}/nginx/sites-available \
mkdir -p ${PATH_WWW_DATA}/mysql \
mkdir -p ${PATH_WWW_DATA}/mongo \
mkdir -p ${PATH_WWW_DATA}/redis \
mkdir -p ${PATH_WWW_DATA}/rabbitmq \
mkdir -p ${PATH_WWW_DATA}/elasticsearch \
mkdir -p ${PATH_WWW_LOG}/php \
mkdir -p ${PATH_WWW_LOG}/nginx 
```

## 环境启动
```
mv /tmp/docker-lnmp ${PATH_WWW_ROOT}/repo
cd ${PATH_WWW_ROOT}/repo/docker-lnmp
docker-compose up -d
```

## 安装结果验证
```
docker ps
```

# 常用命令导入
```
echo 'alias dmysql="docker exec -it docker_mysql_1 /bin/bash"' >> ${SHELL_PROFILE} \
&& echo 'alias dmongo="docker exec -it docker_mongo_1 /bin/bash"' >> ${SHELL_PROFILE} \
&& echo 'alias dmongoex="docker exec -it docker_mongo-express_1 /bin/ash"' >> ${SHELL_PROFILE} \
&& echo 'alias dredis="docker exec -it docker_redis_1 /bin/ash"' >> ${SHELL_PROFILE} \
&& echo 'alias dkafka="docker exec -it docker_kafka_1 /bin/ash"' >> ${SHELL_PROFILE} \
&& echo 'alias drabbitmq="docker exec -it docker_rabbitmq_1 /bin/ash"' >> ${SHELL_PROFILE} \
&& echo 'alias delastic="docker exec -it docker_elastic_1 /bin/ash"' >> ${SHELL_PROFILE} \
&& echo 'alias dphp5="docker exec -it docker_php5-fpm_1 /bin/ash"' >> ${SHELL_PROFILE} \
&& echo 'alias dphp7="docker exec -it docker_php7-fpm_1 /bin/ash"' >> ${SHELL_PROFILE} \
&& echo 'alias dnginx="docker exec -it docker_nginx_1 /bin/ash"' >> ${SHELL_PROFILE} \
&& source ${SHELL_PROFILE}
```

# Demo项目安装
## nginx配置
```
cp ${PATH_WWW_ROOT}/repo/docker-lnmp/nginx/php*.conf ${PATH_WWW_ETC}/nginx/sites-available/
```

## hosts配置
```
sudo -- sh -c -e  "echo 127.0.0.1 'php5-localhost.docker php7-localhost.docker php5-xhgui.docker php7-xhgui.docker' >> /etc/hosts"
```

## 代码安装
```
echo "<?php echo phpinfo();?>" > ${PATH_WWW_ROOT}/repo/index.php
```

## 安装结果验证
### phpinfo方式验证
浏览器访问：

http://php5-localhost.docker

http://php7-localhost.docker

### xhgui方式验证
浏览器访问：

http://php7-xhgui.docker

# 自定义项目安装（Laravel）
## nginx配置
```
cd ${PATH_WWW_ROOT}/repo/docker-lnmp
cp ./nginx/example-laravel.conf ${PATH_WWW_ETC}/nginx/sites-available/laravel-basic.conf
sed -i "" "s|exmaple-laravel|laravel-basic|g" ${PATH_WWW_ETC}/nginx/sites-available/laravel-basic.conf
sed -i "" "s|.docker.raw34.xyz|.docker.mydomain.com|g" ${PATH_WWW_ETC}/nginx/sites-available/laravel-basic.conf
docker-compose restart
```

## hosts配置
```
sudo -- sh -c -e  "echo 127.0.0.1 'laravel-basic.docker.mydomain.com' >> /etc/hosts"
```

## 代码安装
```
cd ${PATH_WWW_ROOT}/repo
git clone git@github.com:raw34/laravel-basic.git
dphp7
cd /www/laravel-basic
cp .env.example .env
composer install -vvv
```

## 安装结果验证
浏览器访问：

http://laravel-basic.docker.mydomain.com


# 自定义项目安装（Yii2）
## nginx配置
```
cd ${PATH_WWW_ROOT}/repo/docker-lnmp
cp ./nginx/example-yii2.conf ${PATH_WWW_ETC}/nginx/sites-available/yii2-basic.conf
sed -i "" "s|example-yii2|yii2-basic|g" ${PATH_WWW_ETC}/nginx/sites-available/yii2-basic.conf
sed -i "" "s|.docker.raw34.xyz|.docker.mydomain.com|g" ${PATH_WWW_ETC}/nginx/sites-available/yii2-basic.conf
docker-compose restart
```

## hosts配置
```
sudo -- sh -c -e  "echo 127.0.0.1 'yii2-basic.docker.mydomain.com' >> /etc/hosts"
```

## 代码安装
```
cd ${PATH_WWW_ROOT}/repo
git clone git@github.com:raw34/yii2-basic.git
dphp7
cd /www/yii2-basic
composer install -vvv
```

## 安装结果验证
浏览器访问：

http://yii2-basic.docker.mydomain.com


# Xhgui配置
如果项目需要利用xhgui分析性能，需要在nginx配置文件中加一行配置，如下示例 :

```
location ~ \.php$ {
    ......
    fastcgi_param PHP_VALUE "auto_prepend_file=/data-php5/xhgui/external/header.php";#php5项目
    #fastcgi_param PHP_VALUE "auto_prepend_file=/data-php7/xhgui/external/header.php";#php7项目
}
```

# 常用命令列表
- 启动环境：docker-compose up -d
- 停止环境：docker-compose down
- 重启环境：docker-compose restart
- 登录mysql容器：dmysql
- 登录redis容器：dredis
- 登录kafka容器：dkafka
- 登录rabbitmq容器：drabbitmq
- 登录elasticsearch容器：delastic
- 登录php5容器：dphp5
- 登录php7容器：dphp7
- 登录nginx容器：dnginx

# Q&A
- 如何修改默认目录

- 如何查看nginx访问日志
```
tail -f ~/wwwlogs/nginx/access.log
```

- 如何查看nginx错误日志
```
tail -f ~/wwwlogs/nginx/error.log
```

- 如何查看php日志 
```
tail -f ~/wwwlogs/php/php*.log
```

- 如何连接redis
```
dredis
redis-cli -a 123456
```

- 如何连接mongo
```
dmongo
mongo 127.0.0.1
```

- 如何连接mysql
```
dmysql
mysql -p123456
```

- 如何查看elasticsearch状态
```
地址：http://localhost:9200
```

- 如何查看rabbitmq状态
```
后台地址：http://localhost:15672
用户名：guest
密码：guest
```
