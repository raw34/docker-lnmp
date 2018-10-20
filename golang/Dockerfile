#
# Golang Dockerfile
#
#

FROM golang:alpine

MAINTAINER raw34 <raw34@sina.com>

RUN \
    mkdir /root/.ssh

RUN \
    mv /etc/apk/repositories /etc/apk/repositories.bak \
    # echo "http://mirror.tuna.tsinghua.edu.cn/alpine/latest-stable/main/" >> /etc/apk/repositories && \
    # echo "http://mirrors.ustc.edu.cn/alpine/latest-stable/main/" >> /etc/apk/repositories && \
    && echo "http://mirrors.aliyun.com/alpine/latest-stable/main/" >> /etc/apk/repositories

# 下载并安装第三方依赖到容器中
# RUN \
    # apk add --no-cache git

# RUN go-wrapper download
# RUN go-wrapper install

# 暴露8080端口
# EXPOSE 8080

# 启动容器时运行 Gin
# CMD ["gin", "run"]

# 告诉 Docker 启动容器运行的命令
# CMD ["go-wrapper", "run"]
