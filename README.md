# 简介
本套环境利用docker-compose搭建，安装后可以直接运行php项目。

目前包含mysql、mongo、redis、kafka、rabbitmq、elasticsearch、php5、php7、nginx镜像，其中php5和php7镜像集成了xhprof和xhgui，可用于分析php程序性能。



# 环境依赖
## Docker

MacOS：[下载地址1](https://download.docker.com/mac/stable/Docker.dmg) [下载地址2](https://dn-dao-github-mirror.qbox.me/docker/install/mac/Docker.dmg)

Windows：[下载地址1](https://download.docker.com/win/stable/Docker%20for%20Windows%20Installer.exe) [下载地址2](https://dn-dao-github-mirror.qbox.me/docker/install/windows/InstallDocker.msi)

Linux：略

## 目录

需要准备一些本地目录（也可以在docker-compose.yaml中调整），创建目录命令如下：

```
mkdir -p ~/wwwetc/nginx/sites-available
mkdir -p ~/wwwroot/repo
mkdir -p ~/wwwdata/mysql
mkdir -p ~/wwwdata/mongo
mkdir -p ~/wwwdata/redis
mkdir -p ~/wwwdata/rabbitmq
mkdir -p ~/wwwdata/elasticsearch
mkdir -p ~/wwwlogs/php
mkdir -p ~/wwwlogs/nginx
```

# 环境安装
```
cd ~/wwwroot/repo
git clone git@github.com:raw34/docker-lnmp.git
cd docker-lnmp
docker-compose up -d
```


# 项目配置
```
cd ~/wwwroot/repo
echo "<?php echo phpinfo();?>" > ~/wwwroot/repo/index.php
git clone 项目地址 项目目录
cd 项目目录
cp .env.local .env
cp ~/wwwroot/repo/docker-lnmp/nginx/example-xxx.conf ~/wwwetc/nginx/sites-available/my-project.conf
// 修改my-project.conf
cd ~/wwwroot/repo/docker-lnmp
docker-compose restart
sudo -- sh -c -e  "echo 127.0.0.1 'php5-localhost.docker php7-localhost.docker php5-xhgui.docker php7-xhgui.docker' >> /etc/hosts"
```



# 项目XHGUI配置
如果项目需要利用xhgui分析性能，需要在nginx配置文件中加一行配置，如下示例 :

```
location ~ \.php$ {
    ......
    fastcgi_param PHP_VALUE "auto_prepend_file=/data-php5/xhgui/external/header.php";#php5项目
    #fastcgi_param PHP_VALUE "auto_prepend_file=/data-php7/xhgui/external/header.php";#php7项目
}
```


# 验证环境安装结果
## phpinfo验证
浏览器访问：

http://php5-localhost.docker

http://php7-localhost.docker

## xhgui后台验证
浏览器访问：

http://php7-xhgui.docker



# 常用命令
## 命令别名导入
```
echo 'alias dmysql="docker exec -it docker_mysql_1 /bin/bash"' >> ~/.bash_profile \
&& echo 'alias dmongo="docker exec -it docker_mongo_1 /bin/bash"' >> ~/.bash_profile \
&& echo 'alias dmongoex="docker exec -it docker_mongo-express_1 /bin/ash"' >> ~/.bash_profile \
&& echo 'alias dredis="docker exec -it docker_redis_1 /bin/ash"' >> ~/.bash_profile \
&& echo 'alias drabbitmq="docker exec -it docker_rabbitmq_1 /bin/ash"' >> ~/.bash_profile \
&& echo 'alias delastic="docker exec -it docker_elastic_1 /bin/ash"' >> ~/.bash_profile \
&& echo 'alias dphp5="docker exec -it docker_php5-fpm_1 /bin/ash"' >> ~/.bash_profile \
&& echo 'alias dphp7="docker exec -it docker_php7-fpm_1 /bin/ash"' >> ~/.bash_profile \
&& echo 'alias dnginx="docker exec -it docker_nginx_1 /bin/ash"' >> ~/.bash_profile \
&& source ~/.bash_profile
```

## 命令列表
- 启动环境：docker-compose up -d
- 停止环境：docker-compose down
- 重启环境：docker-compose restart
- 登录mysql容器：dmysql
- 登录redis容器：dredis
- 登录rabbitmq容器：drabbitmq
- 登录elasticsearch容器：delastic
- 登录php5容器：dphp5
- 登录php7容器：dphp7
- 登录nginx容器：dnginx



# Q&A
如何查看nginx访问日志

如何查看nginx错误日志

如何查看php错误日志

如何查看php项目日志

如何连接redis

如何连接mongo

如何连接mysql

如何查看elasticsearch状态

如何查看rabbitmq状态

